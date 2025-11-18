import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/models/currency.dart';

class CurrencyDropdown extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;

  const CurrencyDropdown({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.currency,
          style: context.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: context.colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colorScheme.onPrimaryFixed),
          ),
          child: DropdownButton<String>(
            value: selectedCurrency,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            icon: const Icon(CupertinoIcons.chevron_down),
            items: Currencies.all.map((Currency currency) {
              return DropdownMenuItem<String>(
                value: currency.code,
                child: Text(
                  '${currency.symbol} ${currency.code} - ${currency.name}',
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onCurrencyChanged(newValue);
              }
            },
          ),
        ),
      ],
    );
  }
}
