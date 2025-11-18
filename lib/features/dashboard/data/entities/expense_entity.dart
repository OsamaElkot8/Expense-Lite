import 'package:equatable/equatable.dart';
import 'dart:convert';

class ExpenseEntity extends Equatable {
  final String id;
  final String category;
  final double amount;
  final String currency;
  final double amountInUSD;
  final DateTime date;
  final String? receiptPath;
  final String? notes;
  final String type; // 'expense' or 'income'

  const ExpenseEntity({
    required this.id,
    required this.category,
    required this.amount,
    required this.currency,
    required this.amountInUSD,
    required this.date,
    this.receiptPath,
    this.notes,
    this.type = 'expense',
  });

  ExpenseEntity copyWith({
    String? id,
    String? category,
    double? amount,
    String? currency,
    double? amountInUSD,
    DateTime? date,
    String? receiptPath,
    String? notes,
    String? type,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      amountInUSD: amountInUSD ?? this.amountInUSD,
      date: date ?? this.date,
      receiptPath: receiptPath ?? this.receiptPath,
      notes: notes ?? this.notes,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'currency': currency,
      'amountInUSD': amountInUSD,
      'date': date.toIso8601String(),
      'receiptPath': receiptPath,
      'notes': notes,
      'type': type,
    };
  }

  factory ExpenseEntity.fromJson(Map<String, dynamic> json) {
    return ExpenseEntity(
      id: json['id'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      amountInUSD: (json['amountInUSD'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      receiptPath: json['receiptPath'] as String?,
      notes: json['notes'] as String?,
      type: json['type'] as String? ?? 'expense',
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory ExpenseEntity.fromJsonString(String jsonString) =>
      ExpenseEntity.fromJson(jsonDecode(jsonString));

  @override
  List<Object?> get props => [
        id,
        category,
        amount,
        currency,
        amountInUSD,
        date,
        receiptPath,
        notes,
        type,
      ];
}
