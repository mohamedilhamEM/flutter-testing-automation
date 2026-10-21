import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Defines standardized font sizes used throughout the application.
/// 
/// This enum provides a consistent typography scale that ensures
/// visual hierarchy and readability across all UI components.
/// 
/// Example usage:
/// ```dart
/// Text(
///   'Hello World',
///   style: platypi(fontSize: FontSize.lg),
/// )
/// ```
enum FontSize {
  /// Extra extra large - 22px (typically for page titles)
  xxl,
  
  /// Extra large - 20px (for section headers)
  xl,
  
  /// Large - 18px (for sub-headers)
  lg,
  
  /// Medium - 16px (default body text)
  md,
  
  /// Small - 14px (secondary text, buttons)
  s,
  
  /// Extra small - 12px (captions, hints)
  xs,
  
  /// Extra extra small - 10px (micro text, badges)
  xxs,
}

/// Extension that converts [FontSize] enum values to actual pixel sizes.
extension FontSizeExtension on FontSize {
  /// Returns the numeric font size in logical pixels.
  double get size {
    switch (this) {
      case FontSize.xxl:
        return 22;
      case FontSize.xl:
        return 20;
      case FontSize.lg:
        return 18;
      case FontSize.md:
        return 16;
      case FontSize.s:
        return 14;
      case FontSize.xs:
        return 12;
      case FontSize.xxs:
        return 10;
    }
  }
}

/// Creates a [TextStyle] using the Platypi font family from Google Fonts.
/// 
/// Platypi is used as the primary font for headings, buttons, and emphasis text.
/// 
/// Example:
/// ```dart
/// Text(
///   'Welcome Back',
///   style: context.headline1(
///     color: context.colorScheme.primary,
///   ),
/// )
/// ```
/// 
/// Parameters:
/// - [fontSize]: Required font size from [FontSize] enum
/// - [color]: Text color, defaults to black
/// - [weight]: Font weight, defaults to regular (400)
/// - [letterSpacing]: Space between letters, defaults to 0
/// - [height]: Line height multiplier
/// - [decoration]: Text decoration (underline, lineThrough, etc.)
TextStyle platypi({
  required FontSize fontSize,
  Color? color,
  FontWeight weight = FontWeight.w400,
  double letterSpacing = 0.0,
  double? height,
  TextDecoration? decoration,
}) =>
    GoogleFonts.platypi(
      color: color,
      fontSize: fontSize.size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );

/// Creates a [TextStyle] using the Noto Sans font family from Google Fonts.
/// 
/// Noto Sans is used as the secondary font for body text and form elements.
/// It provides excellent readability for longer text passages.
/// 
/// Example:
/// ```dart
/// Text(
///   'Enter your email address to continue',
///   style: context.bodyDefault(
///     color: context.colorScheme.onSurfaceVariant,
///   ),
/// )
/// ```
/// 
/// Parameters:
/// - [fontSize]: Required font size from [FontSize] enum
/// - [color]: Text color, defaults to black
/// - [weight]: Font weight, defaults to regular (400)
/// - [letterSpacing]: Space between letters, defaults to 0
/// - [height]: Line height multiplier
/// - [decoration]: Text decoration (underline, lineThrough, etc.)
TextStyle notoSans({
  required FontSize fontSize,
  Color? color,
  FontWeight weight = FontWeight.w400,
  double letterSpacing = 0.0,
  double? height,
  TextDecoration? decoration,
}) =>
    GoogleFonts.notoSans(
      color: color,
      fontSize: fontSize.size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );

// ============================================================================
// Pre-configured Text Styles
// ============================================================================

/// Text style for primary button labels (bold, 14px, Platypi).
/// 
/// Example:
/// ```dart
/// ElevatedButton(
///   child: Text('Sign In', style: context.buttonPrimary()),
/// )
/// ```
TextStyle buttonPrimary(Color color) => platypi(color: color, fontSize: FontSize.s, weight: FontWeight.w700);

/// Text style for secondary button labels (bold, 14px, Platypi).
TextStyle buttonSecondary(Color color) => platypi(color: color, fontSize: FontSize.s, weight: FontWeight.w700);

/// Text style for tertiary/text button labels (bold, 14px, Platypi).
TextStyle buttonTertiary(Color color) => platypi(color: color, fontSize: FontSize.s, weight: FontWeight.w700);

/// Text style for form field body text (regular, 14px, Platypi).
TextStyle formBody(Color color) => platypi(color: color, fontSize: FontSize.s);

/// Text style for form field hints/placeholders (medium, 14px, Noto Sans).
/// 
/// Example:
/// ```dart
/// TextField(
///   decoration: InputDecoration(
///     hintText: 'Enter email',
///     hintStyle: context.formHint(),
///   ),
/// )
/// ```
/// 
/// bottom navbar style


TextStyle formHint(Color color) => notoSans(color: color, fontSize: FontSize.s, weight: FontWeight.w500);

/// Text style for form field labels (medium, 14px, Noto Sans).
TextStyle formLabel(Color color) => notoSans(color: color, fontSize: FontSize.s, weight: FontWeight.w500);

/// Text style for navigation bar action buttons (regular, 16px, Platypi).
TextStyle navBarAction(Color color) => platypi(color: color, fontSize: FontSize.md);

/// Text style for navigation bar titles (medium, 16px, Platypi).
TextStyle navBarTitle(Color color) => platypi(color: color, fontSize: FontSize.md, weight: FontWeight.w500);

/// Text style for selected tab labels (bold, 10px, Platypi).
TextStyle tabSelected(Color color) => platypi(color: color, fontSize: FontSize.xxs, weight: FontWeight.w700);

/// Text style for unselected tab labels (regular, 10px, Platypi).
TextStyle tabUnselected(Color color) => platypi(color: color, fontSize: FontSize.xxs);

// ============================================================================
// BuildContext Extensions for Theme-Aware Text Styles
// ============================================================================

/// Extension on [BuildContext] that provides theme-aware text styles.
/// 
/// These methods automatically use the app's color scheme and allow for
/// easy customization while maintaining consistency.
/// 
/// Example:
/// ```dart
/// Widget build(BuildContext context) {
///   return Text(
///     'Welcome',
///     style: context.headline1(color: context.colorScheme.primary),
///   );
/// }
/// ```
extension TextStyleExtension on BuildContext {
  /// Returns the default text color from the current theme.
  Color get _defaultColor => Theme.of(this).colorScheme.onSurface;

  /// Small body text style (12px, Platypi).
  /// 
  /// Example:
  /// ```dart
  /// Text('Last updated 2 mins ago', style: context.bodySmall())
  /// ```
  TextStyle bodySmall({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => platypi(
        color: color ?? _defaultColor,
        fontSize: FontSize.xs,
        weight: weight ?? FontWeight.w400,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Medium body text style (14px, Platypi).
  /// 
  /// Example:
  /// ```dart
  /// Text('This is a paragraph of text', style: context.bodyDefault())
  /// ```
  TextStyle bodyDefault({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => platypi(
        color: color ?? _defaultColor,
        fontSize: FontSize.s,
        weight: weight ?? FontWeight.w400,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Large body text style (16px, Noto Sans).
  /// 
  /// Example:
  /// ```dart
  /// Text('Important information here', style: context.bodyLarge())
  /// ```
  TextStyle bodyLarge({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => notoSans(
        color: color ?? _defaultColor,
        fontSize: FontSize.md,
        weight: weight ?? FontWeight.w400,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Headline 1 - Largest heading (22px, bold, Platypi).
  /// 
  /// Used for page titles and primary headings.
  /// 
  /// Example:
  /// ```dart
  /// Text('Dashboard', style: context.headline1())
  /// ```
  TextStyle headline1({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => platypi(
        color: color ?? _defaultColor,
        fontSize: FontSize.xxl,
        weight: weight ?? FontWeight.w700,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Headline 2 - Section heading (18px, bold, Platypi).
  /// 
  /// Example:
  /// ```dart
  /// Text('Recent Activity', style: context.headline2())
  /// ```
  TextStyle headline2({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => platypi(
        color: color ?? _defaultColor,
        fontSize: FontSize.lg,
        weight: weight ?? FontWeight.w700,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Headline 3 - Sub-section heading (16px, semi-bold, Platypi).
  TextStyle headline3({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => platypi(
        color: color ?? _defaultColor,
        fontSize: FontSize.md,
        weight: weight ?? FontWeight.w600,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Headline 4 - Card/list item heading (14px, bold, Platypi).
  TextStyle headline4({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => platypi(
        color: color ?? _defaultColor,
        fontSize: FontSize.s,
        weight: weight ?? FontWeight.w700,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Theme-aware button text style (14px, bold, Platypi).
  /// 
  /// Example:
  /// ```dart
  /// TextButton(
  ///   child: Text('Cancel', style: context.buttonPrimary()),
  /// )
  /// ```
  TextStyle buttonPrimary({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => platypi(
        color: color ?? _defaultColor,
        fontSize: FontSize.s,
        weight: weight ?? FontWeight.w700,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Theme-aware form hint text style (14px, medium, Noto Sans).
  TextStyle formHint({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => notoSans(
        color: color ?? _defaultColor,
        fontSize: FontSize.s,
        weight: weight ?? FontWeight.w500,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Theme-aware form label text style (14px, medium, Noto Sans).
  TextStyle formLabel({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => notoSans(
        color: color ?? _defaultColor,
        fontSize: FontSize.s,
        weight: weight ?? FontWeight.w500,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Theme-aware navigation bar action text style (16px, Platypi).
  TextStyle navBarAction({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => platypi(
        color: color ?? _defaultColor,
        fontSize: FontSize.md,
        weight: weight ?? FontWeight.w400,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Theme-aware navigation bar title text style (16px, medium, Platypi).
  TextStyle navBarTitle({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => platypi(
        color: color ?? _defaultColor,
        fontSize: FontSize.md,
        weight: weight ?? FontWeight.w500,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Theme-aware selected tab text style (10px, bold, Platypi).
  TextStyle tabSelected({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => platypi(
        color: color ?? _defaultColor,
        fontSize: FontSize.xxs,
        weight: weight ?? FontWeight.w700,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Theme-aware unselected tab text style (10px, Platypi).
  TextStyle tabUnselected({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => platypi(
        color: color ?? _defaultColor,
        fontSize: FontSize.xxs,
        weight: weight ?? FontWeight.w400,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );

  /// Style for the alert dialog buttons (14px, bold, Platypi).
  TextStyle alertDialogButton({Color? color, double? letterSpacing, double? height, FontWeight? weight}) => platypi(
        color: color ?? _defaultColor,
        fontSize: FontSize.s,
        weight: weight ?? FontWeight.w700,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
      );
}

// ============================================================================
// Fluent Text Style Modifiers
// ============================================================================

/// Extension that provides fluent API for modifying [TextStyle] properties.
/// 
/// This allows for chainable modifications to text styles, making code
/// more readable and expressive.
/// 
/// Example:
/// ```dart
/// Text(
///   'Hello World',
///   style: context.bodyDefault()
///     .bold
///     .italic
///     .setColor(context.colorScheme.primary)
///     .underline,
/// )
/// ```
extension TextStyleFluentExtension on TextStyle {
  /// Applies bold font weight (700).
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  
  /// Applies semi-bold font weight (600).
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  
  /// Applies medium font weight (500).
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  
  /// Applies regular font weight (400).
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  
  /// Applies light font weight (300).
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  
  /// Applies extra light font weight (200).
  TextStyle get extraLight => copyWith(fontWeight: FontWeight.w200);

  /// Applies italic font style.
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  
  /// Sets the text color to [color].
  TextStyle setColor(Color color) => copyWith(color: color);

  /// Applies underline decoration.
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  
  /// Applies line-through (strikethrough) decoration.
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
}
