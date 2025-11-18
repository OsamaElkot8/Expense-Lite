import 'package:expense_tracker_lite/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/storage/hive_service.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'features/dashboard/repositories/expense_repository.dart';
import 'features/dashboard/repositories/api_clients/currency_api_client.dart';
import 'features/dashboard/presentation/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'features/add_expense/presentation/blocs/add_expense_bloc/add_expense_bloc.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DashboardBloc(expenseRepository: ExpenseRepository.instance),
        ),
        BlocProvider(
          create: (context) => AddExpenseBloc(
            expenseRepository: ExpenseRepository.instance,
            currencyApiClient: CurrencyApiClient(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Expense Tracker Lite',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [AppLocalizations.delegate],
        home: const DashboardPage(),
        navigatorKey: NavigationService.navigatorKey,
      ),
    );
  }
}
