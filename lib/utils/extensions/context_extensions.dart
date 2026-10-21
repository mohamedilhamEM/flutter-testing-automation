import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:testingapp/app/app.dart';

/// Extension on [BuildContext] for easy access to theme and screen properties.
///
/// This follows Flutter industry best practices by providing concise
/// access to [ThemeData], [ColorScheme], and screen utilities.
///
/// ## Color Usage
/// ```dart
///  Flutter's built-in theme colors
/// color: context.colorScheme.primary
/// 
///  Custom private colors from ThemeServiceProvider
/// backgroundColor: context.themeColors._primaryColor
/// ```
///
/// ## Screen Size Usage
/// ```dart
/// Instead of: MediaQuery.sizeOf(context).width
/// width: context.screenWidth
/// 
/// Responsive helpers
/// if (context.isMobile) { ... }
/// ```
///
/// ## Theme-Aware
/// All properties automatically update when the theme changes (light/dark mode).
extension BuildContextExtensions on BuildContext {
  // ─────────────────────────────────────────────────────
  // FLUTTER THEME ACCESS (Built-in theme system)
  // ─────────────────────────────────────────────────────
  
  /// Access to the current [ThemeData].
  ThemeData get theme => Theme.of(this);
  
  /// Access to the current [ColorScheme].
  ColorScheme get colorScheme => theme.colorScheme;
  
  // ─────────────────────────────────────────────────────
  // CUSTOM THEME SERVICE ACCESS (Your private colors)
  // ─────────────────────────────────────────────────────
  
  /// Access to [ThemeServiceProvider] for custom private colors.
  ThemeServiceProvider get themeColors => GetIt.instance<ThemeServiceProvider>();
  
  // ─────────────────────────────────────────────────────
  // SCREEN SIZE HELPERS
  // ─────────────────────────────────────────────────────
  
  /// Screen size from MediaQuery.
  Size get screenSize => MediaQuery.sizeOf(this);
  
  /// Screen width.
  double get screenWidth => screenSize.width;
  
  /// Screen height.
  double get screenHeight => screenSize.height;
  
  /// Screen padding (safe area insets).
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);
  
  // ─────────────────────────────────────────────────────
  // RESPONSIVE HELPERS
  // ─────────────────────────────────────────────────────
  
  /// Whether the device is mobile (width < 768px).
  bool get isMobile => screenWidth < 768;
  
  /// Whether the device is tablet (768px ≤ width < 1024px).
  bool get isTablet => screenWidth >= 768 && screenWidth < 1024;
  
  /// Whether the device is desktop (width ≥ 1024px).
  bool get isDesktop => screenWidth >= 1024;
  
  /// Whether the device is in landscape mode.
  bool get isLandscape => screenWidth > screenHeight;
  
  /// Whether the device is in portrait mode.
  bool get isPortrait => screenHeight > screenWidth;
  
  // ─────────────────────────────────────────────────────
  // SAFE AREA HELPERS
  // ─────────────────────────────────────────────────────
  
  /// Safe area top padding (status bar height).
  double get safeAreaTop => screenPadding.top;
  
  /// Safe area bottom padding (navigation bar height).
  double get safeAreaBottom => screenPadding.bottom;
  
  /// Safe area left padding.
  double get safeAreaLeft => screenPadding.left;
  
  /// Safe area right padding.
  double get safeAreaRight => screenPadding.right;
}
