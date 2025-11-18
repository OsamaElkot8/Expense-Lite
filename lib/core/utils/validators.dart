class Validators {
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  static String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a category';
    }
    return null;
  }

  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Please select a date';
    }
    return null;
  }

  static double? parseAmount(String value) {
    return double.tryParse(value.replaceAll(',', '').replaceAll('\$', '').trim());
  }
}

