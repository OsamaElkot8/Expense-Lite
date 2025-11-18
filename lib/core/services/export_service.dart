import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import '../../features/dashboard/repositories/expense_repository.dart';

class ExportService {
  final ExpenseRepository _expenseRepository;

  ExportService(this._expenseRepository);

  Future<void> exportToCSV(String filter) async {
    try {
      final expenses = await _expenseRepository.getExpensesByFilter(filter);

      final List<List<dynamic>> csvData = [
        [
          'Date',
          'Category',
          'Amount',
          'Currency',
          'Amount (USD)',
          'Type',
          'Notes',
        ],
      ];

      for (final expense in expenses) {
        csvData.add([
          DateFormat('yyyy-MM-dd HH:mm:ss').format(expense.date),
          expense.category,
          expense.amount,
          expense.currency,
          expense.amountInUSD,
          expense.type,
          expense.notes ?? '',
        ]);
      }

      final csvString = const ListToCsvConverter().convert(csvData);

      final directory = await getApplicationDocumentsDirectory();
      final sanitizedFilter = filter.replaceAll(' ', '_').toLowerCase();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File(
        '${directory.path}/expenses_${sanitizedFilter}_$timestamp.csv',
      );
      await file.writeAsString(csvString);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Expenses Export - $filter');
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }

  Future<void> exportToPDF(String filter) async {
    try {
      final expenses = await _expenseRepository.getExpensesByFilter(filter);
      final totalBalance = await _expenseRepository.getTotalBalance(filter);
      final totalIncome = await _expenseRepository.getTotalIncome(filter);
      final totalExpenses = await _expenseRepository.getTotalExpenses(filter);

      final pdf = pw.Document();
      final currencyFormat = NumberFormat.currency(
        symbol: '\$',
        decimalDigits: 2,
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Expense Report - $filter',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Total Balance: ${currencyFormat.format(totalBalance)}',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Total Income: ${currencyFormat.format(totalIncome)}',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        'Total Expenses: ${currencyFormat.format(totalExpenses)}',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  pw.Text(
                    'Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Date',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Category',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Amount',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'USD',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Type',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ...expenses.map((expense) {
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            DateFormat('MM/dd/yy').format(expense.date),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(expense.category),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            '${expense.amount.toStringAsFixed(2)} ${expense.currency}',
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            currencyFormat.format(expense.amountInUSD),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(expense.type),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ];
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final sanitizedFilter = filter.replaceAll(' ', '_').toLowerCase();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File(
        '${directory.path}/expenses_${sanitizedFilter}_$timestamp.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Expenses Export - $filter');
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }
}
