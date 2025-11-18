import 'package:equatable/equatable.dart';
import 'package:expense_tracker_lite/features/dashboard/data/entities/expense_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final List<ExpenseEntity> expenses;
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;
  final String currentFilter;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const DashboardLoaded({
    required this.expenses,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.currentFilter,
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  DashboardLoaded copyWith({
    List<ExpenseEntity>? expenses,
    double? totalBalance,
    double? totalIncome,
    double? totalExpenses,
    String? currentFilter,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return DashboardLoaded(
      expenses: expenses ?? this.expenses,
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      currentFilter: currentFilter ?? this.currentFilter,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    expenses,
    totalBalance,
    totalIncome,
    totalExpenses,
    currentFilter,
    currentPage,
    hasMore,
    isLoadingMore,
  ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
