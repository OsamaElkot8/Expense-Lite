import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryBlue = Color(0xFF0F5FEA);
  static const Color primaryBlueDark = Color(0xFF093CBE);
  static const Color primaryBlueLight = Color(0xFF2196F3);

  // Background colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFFFFFFF);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // Income/Expense colors
  static const Color incomeColor = Color(0xFF4CAF50);
  static const Color expenseColor = Color(0xFFF44336);

  // Border colors
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Status colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);

  // Light color scheme
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: primaryBlue,
    secondary: primaryBlueDark,
    tertiary: primaryBlueLight,
    surface: surfaceColor,
    error: errorColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: textPrimary,
    onError: Colors.white,
    onPrimaryContainer: Color(0xFFF5F5F5),
    onPrimaryFixed: Color(0xFFE0E0E0),
  );

  // Dark color scheme
  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: primaryBlueLight,
    secondary: primaryBlue,
    tertiary: primaryBlueDark,
    surface: Color(0xFF1E1E1E),
    error: errorColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.white,
    onPrimaryContainer: Color(0xFFE0E0E0),
    onPrimaryFixed: Color(0xFF616161),
  );
}
