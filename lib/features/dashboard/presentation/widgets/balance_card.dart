import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/export_service.dart';
import '../../repositories/expense_repository.dart';

class BalanceCard extends StatefulWidget {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;
  final String currentFilter;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.currentFilter,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isExporting = false;
  late final ExportService _exportService;

  @override
  void initState() {
    super.initState();
    _exportService = ExportService(ExpenseRepository.instance);
  }

  Future<void> _handleExport(String exportType) async {
    if (_isExporting) return;

    setState(() {
      _isExporting = true;
    });

    try {
      if (exportType == 'export_csv') {
        await _exportService.exportToCSV(widget.currentFilter);
        if (mounted) {
          context.showSuccessSnackBar(
            message: 'Expenses exported to CSV successfully',
          );
        }
      } else if (exportType == 'export_pdf') {
        await _exportService.exportToPDF(widget.currentFilter);
        if (mounted) {
          context.showSuccessSnackBar(
            message: 'Expenses exported to PDF successfully',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar(
          message: e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.totalBalance,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.surface.withValues(alpha: 0.9),
                ),
              ),
              PopupMenuButton<String>(
                icon: _isExporting
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.colorScheme.surface,
                          ),
                        ),
                      )
                    : Icon(Icons.more_vert, color: context.colorScheme.surface),
                color: context.colorScheme.surface,
                enabled: !_isExporting,
                onSelected: _handleExport,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'export_csv',
                    enabled: !_isExporting,
                    child: Row(
                      children: [
                        const Icon(Icons.table_chart, size: 20),
                        const SizedBox(width: 12),
                        Text(context.l10n.exportAsCsv),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'export_pdf',
                    enabled: !_isExporting,
                    child: Row(
                      children: [
                        const Icon(Icons.picture_as_pdf, size: 20),
                        const SizedBox(width: 12),
                        Text(context.l10n.exportAsPdf),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(widget.totalBalance),
            style: context.textTheme.headlineLarge?.copyWith(
              color: context.colorScheme.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                context,
                Icons.arrow_downward,
                context.l10n.income,
                currencyFormat.format(widget.totalIncome),
                AppColors.incomeColor,
              ),
              _buildInfoItem(
                context,
                Icons.arrow_upward,
                context.l10n.expenses,
                currencyFormat.format(widget.totalExpenses),
                AppColors.expenseColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String amount,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.surface.withValues(alpha: 0.8),
              ),
            ),
            Text(
              amount,
              style: context.textTheme.titleSmall?.copyWith(
                color: context.colorScheme.surface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
