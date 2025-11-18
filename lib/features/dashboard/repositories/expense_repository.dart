import 'package:expense_tracker_lite/features/dashboard/data/entities/expense_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/storage/hive_service.dart';
import '../../../core/utils/date_utils.dart';

class ExpenseRepository {
  static ExpenseRepository? _instance;
  Box? _expensesBox;
  Future<Box>? _initializationFuture;

  // Private constructor
  ExpenseRepository._internal();

  // Singleton instance getter
  static ExpenseRepository get instance {
    _instance ??= ExpenseRepository._internal();
    return _instance!;
  }

  // Lazy initialization - ensures box is initialized before use
  Future<Box> _ensureInitialized() async {
    if (_expensesBox != null) {
      return _expensesBox!;
    }

    if (_initializationFuture == null) {
      _initializationFuture = HiveService.openBox(AppConstants.expensesBoxName);
      _expensesBox = await _initializationFuture;
    } else {
      _expensesBox = await _initializationFuture;
    }

    return _expensesBox!;
  }

  Future<void> saveExpense(ExpenseEntity expense) async {
    final box = await _ensureInitialized();
    await box.put(expense.id, expense.toJson());
  }

  Future<List<ExpenseEntity>> getAllExpenses() async {
    final box = await _ensureInitialized();
    final expenses = <ExpenseEntity>[];
    for (var key in box.keys) {
      try {
        final data = box.get(key);
        if (data != null && data is Map) {
          final json = Map<String, dynamic>.from(data);
          expenses.add(ExpenseEntity.fromJson(json));
        }
      } catch (e) {
        // Skip invalid entries
        continue;
      }
    }
    expenses.sort((a, b) => b.date.compareTo(a.date));
    return expenses;
  }

  Future<List<ExpenseEntity>> getExpensesByFilter(String filter) async {
    final allExpenses = await getAllExpenses();

    DateTime startDate;
    switch (filter) {
      case 'This Month':
        startDate = DateUtils.getStartOfMonth();
        break;
      case 'Last 7 Days':
        startDate = DateUtils.getStartOfLast7Days();
        break;
      case 'Last 30 Days':
        startDate = DateUtils.getStartOfLast30Days();
        break;
      case 'This Year':
        startDate = DateUtils.getStartOfYear();
        break;
      case 'All Time':
      default:
        return allExpenses;
    }

    return allExpenses
        .where(
          (expense) =>
              expense.date.isAfter(startDate.subtract(const Duration(days: 1))),
        )
        .toList();
  }

  Future<List<ExpenseEntity>> getExpensesPaginated({
    required String filter,
    required int page,
    required int pageSize,
  }) async {
    final filteredExpenses = await getExpensesByFilter(filter);
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, filteredExpenses.length);

    if (startIndex >= filteredExpenses.length) {
      return [];
    }

    return filteredExpenses.sublist(startIndex, endIndex);
  }

  Future<double> getTotalBalance(String filter) async {
    final expenses = await getExpensesByFilter(filter);
    double balance = 0;

    for (final expense in expenses) {
      if (expense.type == 'income') {
        balance += expense.amountInUSD;
      } else {
        balance -= expense.amountInUSD;
      }
    }

    return balance;
  }

  Future<double> getTotalIncome(String filter) async {
    final expenses = await getExpensesByFilter(filter);
    return expenses
        .where((e) => e.type == 'income')
        .fold(0.0, (sum, e) async => (await sum) + e.amountInUSD);
  }

  Future<double> getTotalExpenses(String filter) async {
    final expenses = await getExpensesByFilter(filter);
    return expenses
        .where((e) => e.type == 'expense')
        .fold(0.0, (sum, e) async => (await sum) + e.amountInUSD);
  }

  Future<void> deleteExpense(String id) async {
    final box = await _ensureInitialized();
    await box.delete(id);
  }

  Future<ExpenseEntity?> getExpenseById(String id) async {
    try {
      final box = await _ensureInitialized();
      final data = box.get(id);
      if (data != null && data is Map) {
        final json = Map<String, dynamic>.from(data);
        return ExpenseEntity.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
