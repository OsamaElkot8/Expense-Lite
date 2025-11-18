class ApiEndpoints {
  static const String baseUrl = 'https://open.er-api.com';
  static const String latestRates = '/v6/latest/USD';

  static String getLatestRates() => '$baseUrl$latestRates';
}
