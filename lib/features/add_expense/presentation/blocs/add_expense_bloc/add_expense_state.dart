import 'package:equatable/equatable.dart';

abstract class AddExpenseState extends Equatable {
  const AddExpenseState();

  @override
  List<Object?> get props => [];
}

class AddExpenseInitial extends AddExpenseState {
  const AddExpenseInitial();
}

class AddExpenseLoaded extends AddExpenseState {
  final String? category;
  final String amount;
  final DateTime? date;
  final String currency;
  final String? receiptPath;
  final bool isLoading;
  final String? errorMessage;

  const AddExpenseLoaded({
    this.category,
    this.amount = '',
    this.date,
    this.currency = 'USD',
    this.receiptPath,
    this.isLoading = false,
    this.errorMessage,
  });

  AddExpenseLoaded copyWith({
    String? category,
    String? amount,
    DateTime? date,
    String? currency,
    String? receiptPath,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddExpenseLoaded(
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      currency: currency ?? this.currency,
      receiptPath: receiptPath ?? this.receiptPath,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isValid {
    return category != null &&
        category!.isNotEmpty &&
        amount.isNotEmpty &&
        date != null;
  }

  @override
  List<Object?> get props => [
        category,
        amount,
        date,
        currency,
        receiptPath,
        isLoading,
        errorMessage,
      ];
}

class AddExpenseSuccess extends AddExpenseState {
  const AddExpenseSuccess();
}

class AddExpenseError extends AddExpenseState {
  final String message;

  const AddExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}

