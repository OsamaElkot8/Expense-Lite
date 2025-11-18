import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_lite/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('validateAmount should return null for valid amount', () {
      expect(Validators.validateAmount('100'), isNull);
      expect(Validators.validateAmount('100.50'), isNull);
      expect(Validators.validateAmount('1,000'), isNull);
    });

    test('validateAmount should return error for empty amount', () {
      expect(Validators.validateAmount(''), isNotNull);
      expect(Validators.validateAmount(null), isNotNull);
    });

    test('validateAmount should return error for invalid amount', () {
      expect(Validators.validateAmount('abc'), isNotNull);
      expect(Validators.validateAmount('12.34.56'), isNotNull);
    });

    test('validateAmount should return error for zero or negative amount', () {
      expect(Validators.validateAmount('0'), isNotNull);
      expect(Validators.validateAmount('-100'), isNotNull);
    });

    test('validateCategory should return null for valid category', () {
      expect(Validators.validateCategory('Groceries'), isNull);
      expect(Validators.validateCategory('Entertainment'), isNull);
    });

    test('validateCategory should return error for empty category', () {
      expect(Validators.validateCategory(''), isNotNull);
      expect(Validators.validateCategory(null), isNotNull);
    });

    test('validateDate should return null for valid date', () {
      expect(Validators.validateDate(DateTime.now()), isNull);
    });

    test('validateDate should return error for null date', () {
      expect(Validators.validateDate(null), isNotNull);
    });

    test('parseAmount should parse valid amounts correctly', () {
      expect(Validators.parseAmount('100'), 100.0);
      expect(Validators.parseAmount('100.50'), 100.50);
      expect(Validators.parseAmount('1,000'), 1000.0);
      expect(Validators.parseAmount('\$100'), 100.0);
      expect(Validators.parseAmount('\$1,000.50'), 1000.50);
    });

    test('parseAmount should return null for invalid amounts', () {
      expect(Validators.parseAmount('abc'), isNull);
      expect(Validators.parseAmount(''), isNull);
    });
  });
}
