import 'package:expense_tracker_lite/core/constants/api_endpoints.dart';
import 'package:expense_tracker_lite/core/constants/error_messages.dart';
import 'package:expense_tracker_lite/core/network/api_client.dart';
import 'package:expense_tracker_lite/features/dashboard/data/entities/currency_rate_entity.dart';

class CurrencyApiClient {
  final ApiClient _apiClient;

  CurrencyApiClient({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<CurrencyRateEntity> getLatestRates() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getLatestRates());

      if (response.containsKey('rates') && response.containsKey('base_code')) {
        final rates = Map<String, double>.from(
          (response['rates'] as Map).map(
            (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
          ),
        );

        return CurrencyRateEntity(
          baseCurrency: response['base_code'] as String? ?? 'USD',
          rates: rates,
          lastUpdated: DateTime.now(),
        );
      } else {
        throw Exception(ErrorMessages.currencyConversionError);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(ErrorMessages.currencyConversionError);
    }
  }

  Future<double> convertToUSD(double amount, String fromCurrency) async {
    if (fromCurrency == 'USD') {
      return amount;
    }

    try {
      final rates = await getLatestRates();
      final rate = rates.rates[fromCurrency];

      if (rate == null) {
        throw Exception('Currency rate not found for $fromCurrency');
      }

      // Convert from currency to USD
      // If rate is for USD to currency, we need to invert it
      // The API returns rates as USD to other currencies
      return amount / rate;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(ErrorMessages.currencyConversionError);
    }
  }
}
