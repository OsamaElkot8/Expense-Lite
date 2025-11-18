import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../dashboard/repositories/expense_repository.dart';
import '../../../../dashboard/repositories/api_clients/currency_api_client.dart';
import '../../../../dashboard/data/entities/expense_entity.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/error_messages.dart';
import '../../../../../core/utils/validators.dart';
import 'add_expense_event.dart';
import 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final ExpenseRepository _expenseRepository;
  final CurrencyApiClient _currencyApiClient;

  AddExpenseBloc({
    required ExpenseRepository expenseRepository,
    CurrencyApiClient? currencyApiClient,
  }) : _expenseRepository = expenseRepository,
       _currencyApiClient = currencyApiClient ?? CurrencyApiClient(),
       super(const AddExpenseLoaded()) {
    on<AddExpenseInitialized>(_onInitialized);
    on<AddExpenseCategoryChanged>(_onCategoryChanged);
    on<AddExpenseAmountChanged>(_onAmountChanged);
    on<AddExpenseDateChanged>(_onDateChanged);
    on<AddExpenseCurrencyChanged>(_onCurrencyChanged);
    on<AddExpenseReceiptChanged>(_onReceiptChanged);
    on<AddExpenseSubmitted>(_onSubmitted);
    on<AddExpenseReset>(_onReset);
  }

  void _onInitialized(
    AddExpenseInitialized event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(
      const AddExpenseLoaded(
        currency: AppConstants.defaultCurrency,
        date: null,
      ),
    );
  }

  void _onCategoryChanged(
    AddExpenseCategoryChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    if (state is AddExpenseLoaded) {
      final currentState = state as AddExpenseLoaded;
      emit(currentState.copyWith(category: event.category));
    }
  }

  void _onAmountChanged(
    AddExpenseAmountChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    if (state is AddExpenseLoaded) {
      final currentState = state as AddExpenseLoaded;
      emit(currentState.copyWith(amount: event.amount));
    }
  }

  void _onDateChanged(
    AddExpenseDateChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    if (state is AddExpenseLoaded) {
      final currentState = state as AddExpenseLoaded;
      emit(currentState.copyWith(date: event.date));
    }
  }

  void _onCurrencyChanged(
    AddExpenseCurrencyChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    if (state is AddExpenseLoaded) {
      final currentState = state as AddExpenseLoaded;
      emit(currentState.copyWith(currency: event.currency));
    }
  }

  void _onReceiptChanged(
    AddExpenseReceiptChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    if (state is AddExpenseLoaded) {
      final currentState = state as AddExpenseLoaded;
      emit(currentState.copyWith(receiptPath: event.receiptPath));
    }
  }

  Future<void> _onSubmitted(
    AddExpenseSubmitted event,
    Emitter<AddExpenseState> emit,
  ) async {
    if (state is AddExpenseLoaded) {
      final currentState = state as AddExpenseLoaded;

      // Validate
      if (!currentState.isValid) {
        emit(
          currentState.copyWith(
            errorMessage: ErrorMessages.pleaseFillAllFields,
          ),
        );
        return;
      }

      final amount = Validators.parseAmount(currentState.amount);
      if (amount == null || amount <= 0) {
        emit(currentState.copyWith(errorMessage: ErrorMessages.invalidAmount));
        return;
      }

      emit(currentState.copyWith(isLoading: true, clearError: true));

      try {
        // Convert to USD
        double amountInUSD;
        if (currentState.currency == AppConstants.baseCurrency) {
          amountInUSD = amount;
        } else {
          amountInUSD = await _currencyApiClient.convertToUSD(
            amount,
            currentState.currency,
          );
        }

        // Create expense entity
        final expense = ExpenseEntity(
          id: const Uuid().v4(),
          category: currentState.category!,
          amount: amount,
          currency: currentState.currency,
          amountInUSD: amountInUSD,
          date: currentState.date!,
          receiptPath: currentState.receiptPath,
          type: 'expense',
        );

        // Save expense
        await _expenseRepository.saveExpense(expense);

        emit(const AddExpenseSuccess());
      } catch (e) {
        emit(AddExpenseError(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }

  void _onReset(AddExpenseReset event, Emitter<AddExpenseState> emit) {
    emit(const AddExpenseLoaded(currency: AppConstants.defaultCurrency));
  }
}
