import 'package:expense_tracker_lite/features/dashboard/data/entities/expense_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/models/expense_category.dart';
import '../../../../core/models/currency.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;

class ExpenseItem extends StatelessWidget {
  final ExpenseEntity expense;
  final VoidCallback? onDelete;

  const ExpenseItem({super.key, required this.expense, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final category = ExpenseCategories.getByName(expense.category);
    final currency = Currencies.getByCode(expense.currency);
    final originalCurrencyFormat = NumberFormat.currency(
      symbol: currency?.symbol ?? expense.currency,
      decimalDigits: 2,
    );
    final usdCurrencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (category?.color ?? Colors.blue).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category?.icon ?? Icons.category,
              color: category?.color ?? Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.category,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.manually,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Original amount with currency symbol
              Text(
                '- ${originalCurrencyFormat.format(expense.amount)}',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.error,
                ),
              ),
              // Converted USD amount (shown only if different currency)
              if (expense.currency != 'USD')
                Text(
                  '≈ ${usdCurrencyFormat.format(expense.amountInUSD)}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                date_utils.DateUtils.formatDateTimeWithRelative(expense.date),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 16),

            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 20,
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              onSelected: (value) {
                if (value == 'delete') {
                  onDelete?.call();
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: context.colorScheme.error,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Delete',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
