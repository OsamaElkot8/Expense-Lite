import 'package:equatable/equatable.dart';

class CurrencyRateEntity extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime lastUpdated;

  const CurrencyRateEntity({
    required this.baseCurrency,
    required this.rates,
    required this.lastUpdated,
  });

  CurrencyRateEntity copyWith({
    String? baseCurrency,
    Map<String, double>? rates,
    DateTime? lastUpdated,
  }) {
    return CurrencyRateEntity(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      rates: rates ?? this.rates,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [baseCurrency, rates, lastUpdated];
}
