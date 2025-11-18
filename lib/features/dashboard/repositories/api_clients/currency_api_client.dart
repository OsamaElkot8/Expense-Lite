import 'package:expense_tracker_lite/core/constants/api_endpoints.dart';
import 'package:expense_tracker_lite/core/constants/error_messages.dart';
import 'package:expense_tracker_lite/core/network/api_client.dart';
import 'package:expense_tracker_lite/core/network/api_response.dart';
import 'package:expense_tracker_lite/features/dashboard/data/entities/currency_rate_entity.dart';

class CurrencyApiClient {
  final ApiClient _apiClient = ApiClient();

  CurrencyApiClient._privateConstructor();
  static final CurrencyApiClient _instance =
      CurrencyApiClient._privateConstructor();
  factory CurrencyApiClient() => _instance;

  Future<ApiResponse<CurrencyRateEntity>> getLatestRates() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getLatestRates());

      if (response.containsKey('rates') && response.containsKey('base_code')) {
        final rates = Map<String, double>.from(
          (response['rates'] as Map).map(
            (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
          ),
        );

        return ApiResponse(
          data: CurrencyRateEntity(
            baseCurrency: response['base_code'] as String? ?? 'USD',
            rates: rates,
            lastUpdated: DateTime.now(),
          ),
          status: true,
          message: 'Latest Rates fetched successfully',
        );
      } else {
        throw Exception(ErrorMessages.currencyConversionError);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      return ApiResponse(
        data: null,
        status: false,
        message: ErrorMessages.currencyConversionError,
      );
    }
  }

  Future<ApiResponse<double>> convertToUSD(
    double amount,
    String fromCurrency,
  ) async {
    if (fromCurrency == 'USD') {
      return ApiResponse(
        data: amount,
        status: true,
        message: 'Curency Converted successfully',
      );
    }

    try {
      final response = await getLatestRates();
      if (response.status) {
        final rate = response.data?.rates[fromCurrency];

        if (rate == null) {
          throw Exception('Currency rate not found for $fromCurrency');
        }

        // Convert from currency to USD
        // If rate is for USD to currency, we need to invert it
        // The API returns rates as USD to other currencies
        return ApiResponse(
          data: amount / rate,
          status: true,
          message: 'Curency Converted successfully',
        );
      } else {
        throw Exception(response.message ?? 'Unknown error');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      return ApiResponse(
        data: null,
        status: false,
        message: ErrorMessages.currencyConversionError,
      );
    }
  }
}
