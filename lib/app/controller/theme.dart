import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testingapp/app/app.dart';

/// A service provider class for managing the theme of the application.
/// This class provides methods to toggle the theme between light and dark,
/// and retrieve the current theme data and mode.
///
/// **Important**: Don't make colors public
/// Always access through [Theme] using [BuildContext]
///
/// Example Usage:
///
/// ```dart
/// color: Theme.of(context).colorScheme.primary
/// ```
class ThemeServiceProvider with ChangeNotifier {
  ThemeServiceProvider({bool isDark = false}) : _isDark = isDark;

  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get lightTheme => _lightThemeData();
  ThemeData get darkTheme => _darkThemeData();
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    unawaited(Hive.box<bool>('themeMode').put('isDark', _isDark));
    notifyListeners();
  }

  /// **Important**: Don't make colors public
  final Color _primaryColor = const Color(0xFF127592);
  final Color _secondaryColor = const Color(0xFF7FD0D3);
  final Color _lightSurfaceColor = Colors.white;
  final Color _darkSurfaceColor = const Color(0xFF023047);
  final Color _lightBackgroundColor = const Color(0xFFF7F7F7);
  final Color _darkBackgroundColor = const Color(0xFF000000);
  final Color _lightShadowColor = const Color(0xFFE2E8F0);
  final Color _darkShadowColor = const Color(0xFF0D1117);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _onSurfaceColor = const Color(0xFF000000);
  final Color _onSurfaceColorDark = const Color(0xFFF7F7F7);
  final Color _successColorLight = const Color(0xFF2E7D32);
  final Color _successColorDark = const Color(0xFF81C784);
  final Color _warningColorLight = const Color(0xFFED6C02);
  final Color _warningColorDark = const Color(0xFFFFB74D);
  final Color _lightBorderColor = const Color(0xFFC6DEE0);
  final Color _darkBorderColor = const Color(0xFF262D2E);
  final Color _lightTrackColor = const Color(0xFFE5E7EB);
  final Color _darkTrackColor = const Color(0xFF374151);

  Color get shimmersColor => _primaryColor.withValues(alpha: 0.24);
  Color get shimmerHighlightColor => _secondaryColor.withValues(alpha: 0.2);

  Color get successColor => _isDark ? _successColorDark : _successColorLight;
  Color get onSuccessColor => Colors.white;
  Color get warningColor => _isDark ? _warningColorDark : _warningColorLight;
  Color get onWarningColor => Colors.white;

  Color get passwordWeakColor => _errorColor;
  Color get passwordMediumColor => warningColor;
  Color get passwordStrongColor => successColor;
  Color get passwordTrackColor => _isDark ? _darkTrackColor : _lightTrackColor;

  ThemeData _lightThemeData() {
    return ThemeData(
      scaffoldBackgroundColor: _lightBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        onPrimary: Colors.white,
        secondary: _secondaryColor,
        onSecondary: Colors.white,
        surface: _lightSurfaceColor,
        onSurface: _onSurfaceColor,
        shadow: _lightShadowColor,
        outline: const Color(0xFF90A4AE),
        error: _errorColor,
      ),
      fontFamily: _fontFamily(),
      elevatedButtonTheme: _elevatedButtonThemeData(isDark: false),
      outlinedButtonTheme: _outlinedButtonThemeData(isDark: false),
      textButtonTheme: _textButtonThemeData(isDark: false),
      inputDecorationTheme: _inputDecorationTheme(isDark: false),
      appBarTheme: _appBarTheme(),
      iconTheme: _iconThemeData(isDark: false),
      bottomNavigationBarTheme: _bottomNavigationBarThemeData(isDark: false),
      iconButtonTheme: _iconButtonThemeData(isDark: false),
    );
  }

  ThemeData _darkThemeData() {
    return ThemeData(
      scaffoldBackgroundColor: _darkBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: _primaryColor,
        primary: _primaryColor,
        onPrimary: Colors.white,
        secondary: _secondaryColor,
        onSecondary: Colors.white,
        surface: _darkSurfaceColor,
        onSurface: _onSurfaceColorDark,
        shadow: _darkShadowColor,
        outline: const Color(0xFF90A4AE),
        error: _errorColor,
      ),
      fontFamily: _fontFamily(),
      elevatedButtonTheme: _elevatedButtonThemeData(isDark: true),
      outlinedButtonTheme: _outlinedButtonThemeData(isDark: true),
      textButtonTheme: _textButtonThemeData(isDark: true),
      inputDecorationTheme: _inputDecorationTheme(isDark: true),
      appBarTheme: _appBarTheme(),
      iconTheme: _iconThemeData(isDark: true),
      bottomNavigationBarTheme: _bottomNavigationBarThemeData(isDark: true),
      iconButtonTheme: _iconButtonThemeData(isDark: true),
    );
  }

  String? _fontFamily() {
    return GoogleFonts.poppins().fontFamily;
  }

  ElevatedButtonThemeData _elevatedButtonThemeData({required bool isDark}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _primaryColor,
        elevation: 0,
        textStyle: buttonPrimary(_primaryColor),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  OutlinedButtonThemeData _outlinedButtonThemeData({required bool isDark}) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? _lightSurfaceColor : _primaryColor,
        backgroundColor: isDark ? _darkSurfaceColor : _lightSurfaceColor,
        elevation: 0,
        textStyle: buttonSecondary(isDark ? _lightSurfaceColor : _primaryColor),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  TextButtonThemeData _textButtonThemeData({required bool isDark}) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColor,
        elevation: 0,
        textStyle: buttonTertiary(_primaryColor),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        maximumSize: const Size(double.infinity, 48),
      ),
    );
  }

    IconButtonThemeData _iconButtonThemeData({required bool isDark}) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
      ),
    );
  }

  InputDecorationTheme _inputDecorationTheme({required bool isDark}) {
    final borderColor = isDark ? _darkBorderColor : _lightBorderColor;
    return InputDecorationTheme(      
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: borderColor, // Border color when the field is enabled
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _primaryColor, // Border color when the field is focused
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _errorColor, // Border color when validation fails
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _errorColor, // Border color when focused but has an error
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: borderColor.withValues(alpha: 0.5), // Disabled border color
        ),
      ),
      filled: true,
      fillColor: isDark ? _darkSurfaceColor : _lightSurfaceColor,
      hintStyle: formHint(isDark ? _onSurfaceColorDark : _onSurfaceColor),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    );
  }

  AppBarTheme _appBarTheme() {
    return AppBarTheme(
      foregroundColor: isDark ? _lightBackgroundColor : _darkBackgroundColor,
      backgroundColor: isDark ? _darkSurfaceColor : _lightSurfaceColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: isDark ? _lightBackgroundColor : _darkBackgroundColor,
      ),
      titleTextStyle: navBarTitle(
        isDark ? _lightBackgroundColor : _darkBackgroundColor,
      ),
    );
  }

  IconThemeData _iconThemeData({required bool isDark}) {
    return IconThemeData(
      color: isDark ? _lightBackgroundColor : _darkBackgroundColor,
    );
  }

  BottomNavigationBarThemeData _bottomNavigationBarThemeData({required bool isDark}) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? _darkSurfaceColor : _lightSurfaceColor,
      type: BottomNavigationBarType.fixed,
      elevation: 16,
      selectedItemColor: _primaryColor,
      unselectedItemColor: isDark ? _lightBackgroundColor : _darkBackgroundColor,
      showUnselectedLabels: true,
      selectedLabelStyle: tabSelected(_isDark ? _lightBackgroundColor : _darkBackgroundColor),
      unselectedLabelStyle: tabUnselected(_isDark ? _lightBackgroundColor : _darkBackgroundColor),
    );
  }

  static void setSystemUIOverlayStyle({bool isDark = false}) {
    if (isDark) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }
}
