class Currency {
  final String code;
  final String name;
  final String symbol;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });
}

class Currencies {
  static const List<Currency> all = [
    Currency(code: 'USD', name: 'US Dollar', symbol: '\$'),
    Currency(code: 'EUR', name: 'Euro', symbol: '€'),
    Currency(code: 'GBP', name: 'British Pound', symbol: '£'),
    Currency(code: 'JPY', name: 'Japanese Yen', symbol: '¥'),
    Currency(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$'),
    Currency(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$'),
    Currency(code: 'CHF', name: 'Swiss Franc', symbol: 'CHF'),
    Currency(code: 'CNY', name: 'Chinese Yuan', symbol: '¥'),
    Currency(code: 'INR', name: 'Indian Rupee', symbol: '₹'),
    Currency(code: 'SGD', name: 'Singapore Dollar', symbol: 'S\$'),
    Currency(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ'),
    Currency(code: 'SAR', name: 'Saudi Riyal', symbol: 'ر.س'),
    Currency(code: 'EGP', name: 'Egyptian Pound', symbol: 'E£'),
  ];

  static Currency? getByCode(String code) {
    try {
      return all.firstWhere((currency) => currency.code == code);
    } catch (e) {
      return null;
    }
  }
}

