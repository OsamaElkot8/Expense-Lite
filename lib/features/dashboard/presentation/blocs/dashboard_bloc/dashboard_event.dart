import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardInitialized extends DashboardEvent {
  const DashboardInitialized();
}

class DashboardFilterChanged extends DashboardEvent {
  final String filter;

  const DashboardFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class DashboardLoadMoreExpenses extends DashboardEvent {
  const DashboardLoadMoreExpenses();
}

class DashboardRefresh extends DashboardEvent {
  const DashboardRefresh();
}

class DashboardExpenseDeleted extends DashboardEvent {
  final String expenseId;

  const DashboardExpenseDeleted(this.expenseId);

  @override
  List<Object?> get props => [expenseId];
}

