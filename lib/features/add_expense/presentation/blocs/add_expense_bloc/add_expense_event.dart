import 'package:equatable/equatable.dart';

abstract class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object?> get props => [];
}

class AddExpenseInitialized extends AddExpenseEvent {
  const AddExpenseInitialized();
}

class AddExpenseCategoryChanged extends AddExpenseEvent {
  final String category;

  const AddExpenseCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class AddExpenseAmountChanged extends AddExpenseEvent {
  final String amount;

  const AddExpenseAmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

class AddExpenseDateChanged extends AddExpenseEvent {
  final DateTime date;

  const AddExpenseDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class AddExpenseCurrencyChanged extends AddExpenseEvent {
  final String currency;

  const AddExpenseCurrencyChanged(this.currency);

  @override
  List<Object?> get props => [currency];
}

class AddExpenseReceiptChanged extends AddExpenseEvent {
  final String? receiptPath;

  const AddExpenseReceiptChanged(this.receiptPath);

  @override
  List<Object?> get props => [receiptPath];
}

class AddExpenseSubmitted extends AddExpenseEvent {
  const AddExpenseSubmitted();
}

class AddExpenseReset extends AddExpenseEvent {
  const AddExpenseReset();
}

