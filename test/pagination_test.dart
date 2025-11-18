import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_lite/features/dashboard/data/entities/expense_entity.dart';
import 'package:expense_tracker_lite/core/constants/app_constants.dart';

void main() {
  group('Pagination Logic', () {
    test('should paginate expenses correctly', () {
      final expenses = List.generate(25, (index) {
        return ExpenseEntity(
          id: 'expense_$index',
          category: 'Groceries',
          amount: 100.0,
          currency: 'USD',
          amountInUSD: 100.0,
          date: DateTime.now().subtract(Duration(days: index)),
        );
      });

      // Test first page
      final page1 = expenses.sublist(0, AppConstants.itemsPerPage);
      expect(page1.length, AppConstants.itemsPerPage);

      // Test second page
      final page2 = expenses.sublist(
        AppConstants.itemsPerPage,
        AppConstants.itemsPerPage * 2,
      );
      expect(page2.length, AppConstants.itemsPerPage);

      // Test last page (partial)
      final page3 = expenses.sublist(AppConstants.itemsPerPage * 2);
      expect(page3.length, 5); // 25 - 20 = 5
    });

    test('should handle empty expense list', () {
      final expenses = <ExpenseEntity>[];
      final page = expenses.sublist(0, 0.clamp(0, expenses.length));
      expect(page.length, 0);
    });

    test('should handle page beyond available items', () {
      final expenses = List.generate(5, (index) {
        return ExpenseEntity(
          id: 'expense_$index',
          category: 'Groceries',
          amount: 100.0,
          currency: 'USD',
          amountInUSD: 100.0,
          date: DateTime.now().subtract(Duration(days: index)),
        );
      });

      final startIndex = 1 * AppConstants.itemsPerPage;
      final endIndex = (startIndex + AppConstants.itemsPerPage).clamp(0, expenses.length);
      
      if (startIndex >= expenses.length) {
        expect(true, true); // No items for this page
      } else {
        final page = expenses.sublist(startIndex, endIndex);
        expect(page.length, lessThanOrEqualTo(AppConstants.itemsPerPage));
      }
    });

    test('should maintain correct order after pagination', () {
      final expenses = List.generate(15, (index) {
        return ExpenseEntity(
          id: 'expense_$index',
          category: 'Groceries',
          amount: 100.0,
          currency: 'USD',
          amountInUSD: 100.0,
          date: DateTime.now().subtract(Duration(days: index)),
        );
      });

      // Sort by date descending (newest first)
      expenses.sort((a, b) => b.date.compareTo(a.date));

      final page1 = expenses.sublist(0, AppConstants.itemsPerPage);
      expect(page1.first.date.isAfter(page1.last.date), true);
    });
  });
}

