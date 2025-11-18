import 'package:expense_tracker_lite/features/dashboard/repositories/expense_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/error_messages.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ExpenseRepository _expenseRepository;

  DashboardBloc({required ExpenseRepository expenseRepository})
    : _expenseRepository = expenseRepository,
      super(const DashboardInitial()) {
    on<DashboardInitialized>(_onInitialized);
    on<DashboardFilterChanged>(_onFilterChanged);
    on<DashboardLoadMoreExpenses>(_onLoadMoreExpenses);
    on<DashboardRefresh>(_onRefresh);
    on<DashboardExpenseDeleted>(_onExpenseDeleted);
  }

  Future<void> _onInitialized(
    DashboardInitialized event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    await _loadDashboardData(emit, AppConstants.filterOptions.first, 0);
  }

  Future<void> _onFilterChanged(
    DashboardFilterChanged event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(isLoadingMore: true));
    } else {
      emit(const DashboardLoading());
    }
    await _loadDashboardData(emit, event.filter, 0);
  }

  Future<void> _onLoadMoreExpenses(
    DashboardLoadMoreExpenses event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      if (!currentState.hasMore || currentState.isLoadingMore) {
        return;
      }

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final nextPage = currentState.currentPage + 1;
        final newExpenses = await _expenseRepository.getExpensesPaginated(
          filter: currentState.currentFilter,
          page: nextPage,
          pageSize: AppConstants.itemsPerPage,
        );

        final hasMore = newExpenses.length == AppConstants.itemsPerPage;

        // THIS LINE OF CODE IS ADDED FOR MORE REALISTIC DATA RETRIEVING SIMULATION
        // short delay to display loading more indicator for a short period, since local storage is fast to retrieve
        await Future.delayed(const Duration(seconds: 3));

        emit(
          currentState.copyWith(
            expenses: [...currentState.expenses, ...newExpenses],
            currentPage: nextPage,
            hasMore: hasMore,
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        emit(DashboardError(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }

  Future<void> _onRefresh(
    DashboardRefresh event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      await _loadDashboardData(emit, currentState.currentFilter, 0);
    } else {
      await _loadDashboardData(emit, AppConstants.filterOptions.first, 0);
    }
  }

  Future<void> _onExpenseDeleted(
    DashboardExpenseDeleted event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      await _expenseRepository.deleteExpense(event.expenseId);
      if (state is DashboardLoaded) {
        final currentState = state as DashboardLoaded;
        await _loadDashboardData(emit, currentState.currentFilter, 0);
      }
    } catch (e) {
      emit(DashboardError(ErrorMessages.deleteExpenseError));
    }
  }

  Future<void> _loadDashboardData(
    Emitter<DashboardState> emit,
    String filter,
    int page,
  ) async {
    try {
      final expenses = await _expenseRepository.getExpensesPaginated(
        filter: filter,
        page: page,
        pageSize: AppConstants.itemsPerPage,
      );

      final totalBalance = await _expenseRepository.getTotalBalance(filter);
      final totalIncome = await _expenseRepository.getTotalIncome(filter);
      final totalExpenses = await _expenseRepository.getTotalExpenses(filter);

      final hasMore = expenses.length == AppConstants.itemsPerPage;

      emit(
        DashboardLoaded(
          expenses: expenses,
          totalBalance: totalBalance,
          totalIncome: totalIncome,
          totalExpenses: totalExpenses,
          currentFilter: filter,
          currentPage: page,
          hasMore: hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(DashboardError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
