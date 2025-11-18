class AppConstants {
  // Pagination
  static const int itemsPerPage = 10;

  // Currency
  static const String baseCurrency = 'USD';
  static const String defaultCurrency = 'USD';

  // Date formats
  static const String dateFormat = 'MM/dd/yy';
  static const String dateTimeFormat = 'MM/dd/yy hh:mm a';

  // Storage keys
  static const String expensesBoxName = 'expenses';
  static const String currencyRatesBoxName = 'currency_rates';
  static const String userPreferencesBoxName = 'user_preferences';

  // User defaults
  static const String userName = 'Shihab Rahman';
  static const String userProfileImageUrl = '';

  // Filter options
  static const List<String> filterOptions = [
    'This Month',
    'Last 7 Days',
    'Last 30 Days',
    'This Year',
    'All Time',
  ];
}
