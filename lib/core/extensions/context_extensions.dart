import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../utils/page_transitions.dart';

extension ContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get statusBarHeight => MediaQuery.of(this).padding.top;

  bool get canPop => Navigator.canPop(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);

  Future<T?> navigatorPush<T>({
    required Widget child,
    bool animated = true,
  }) async {
    if (animated) {
      return await Navigator.push<T>(this, SlidePageRoute<T>(child: child));
    } else {
      return await Navigator.push<T>(
        this,
        MaterialPageRoute<T>(builder: (_) => child),
      );
    }
  }

  Future<T?> navigatorPushReplacement<T, TO>({required Widget child}) async =>
      await Navigator.pushReplacement<T, TO>(
        this,
        MaterialPageRoute(builder: (_) => child),
      );

  Future<T?> pushNewScreenWithRouteSettings<T>({
    required final Widget screen,
    required final RouteSettings settings,
  }) => Navigator.of(
    this,
  ).push<T>(MaterialPageRoute<T>(settings: settings, builder: (ctx) => screen));

  Future<T?> pushReplacementNewScreenWithRouteSettings<T, TO>({
    required final Widget screen,
    required final RouteSettings settings,
  }) => Navigator.of(this).pushReplacement<T, TO>(
    MaterialPageRoute(settings: settings, builder: (ctx) => screen),
  );

  void navigatorPop([Object? result]) => Navigator.of(this).pop(result);

  void showSnackBarMessage({required String message, Color? backgroundColor}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void showErrorSnackBar({required String message}) {
    showSnackBarMessage(
      message: message,
      backgroundColor: Theme.of(this).colorScheme.error,
    );
  }

  void showSuccessSnackBar({required String message}) {
    showSnackBarMessage(message: message, backgroundColor: Colors.green);
  }
}
