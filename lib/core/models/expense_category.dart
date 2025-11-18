import 'package:flutter/material.dart';

class ExpenseCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.color = Colors.blue,
  });
}

class ExpenseCategories {
  static const List<ExpenseCategory> all = [
    ExpenseCategory(
      id: 'groceries',
      name: 'Groceries',
      icon: Icons.shopping_cart,
      color: Colors.green,
    ),
    ExpenseCategory(
      id: 'entertainment',
      name: 'Entertainment',
      icon: Icons.movie,
      color: Colors.purple,
    ),
    ExpenseCategory(
      id: 'gas',
      name: 'Gas',
      icon: Icons.local_gas_station,
      color: Colors.orange,
    ),
    ExpenseCategory(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Colors.pink,
    ),
    ExpenseCategory(
      id: 'news_paper',
      name: 'News Paper',
      icon: Icons.newspaper,
      color: Colors.brown,
    ),
    ExpenseCategory(
      id: 'transport',
      name: 'Transport',
      icon: Icons.directions_car,
      color: Colors.blue,
    ),
    ExpenseCategory(
      id: 'rent',
      name: 'Rent',
      icon: Icons.home,
      color: Colors.indigo,
    ),
  ];

  static ExpenseCategory? getById(String id) {
    try {
      return all.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  static ExpenseCategory? getByName(String name) {
    try {
      return all.firstWhere((category) => category.name == name);
    } catch (e) {
      return null;
    }
  }
}

