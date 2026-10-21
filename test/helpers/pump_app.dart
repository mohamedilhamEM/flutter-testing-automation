import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testingapp/l10n/gen/app_localizations.dart';

/// A helper function to pump a widget with Material app, theme, and localization support.
/// 
/// This is useful for widget tests that need the full app context.
/// 
/// Example:
/// ```dart
/// await tester.pumpApp(
///   CommonButton.primary(
///     label: 'Test Button',
///     onPressed: () {},
///   ),
/// );
/// ```
extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    ThemeMode themeMode = ThemeMode.light,
    NavigatorObserver? navigatorObserver,
  }) {
    return pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: themeMode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: widget),
          navigatorObservers: navigatorObserver != null ? [navigatorObserver] : [],
        ),
      ),
    );
  }

  /// Pumps a widget in a [Scaffold] with proper Material app context.
  Future<void> pumpScaffold(Widget widget) {
    return pumpApp(
      Scaffold(
        body: widget,
      ),
    );
  }
}
