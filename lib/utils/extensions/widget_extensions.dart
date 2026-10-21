import 'package:flutter/material.dart';
import 'package:testingapp/utils/utils.dart';

/// Simplified widget extensions for common UI patterns
extension WidgetExtensions on Widget {
  // ═══════════════════════════════════════════════════════════════
  // PADDING EXTENSIONS
  // ═══════════════════════════════════════════════════════════════

  /// Adds custom padding using EdgeInsets
  ///
  /// Example:
  /// ```dart
  /// Text('Custom').pad(EdgeInsets.only(left: 20, top: 10))
  /// ```
  Widget pad(EdgeInsets padding) => Padding(
        padding: padding,
        child: this,
      );

  // Preset horizontal padding shortcuts
  Widget get padHorizontal4 => pad(AppSpacing.horizontalXs4);
  Widget get padHorizontal8 => pad(AppSpacing.horizontalSm8);
  Widget get padHorizontal12 => pad(AppSpacing.horizontalMd12);
  Widget get padHorizontal16 => pad(AppSpacing.horizontalMd16);
  Widget get padHorizontal24 => pad(AppSpacing.horizontalLg24);
  Widget get padHorizontal32 => pad(AppSpacing.horizontalXl32);

  // Preset vertical padding shortcuts
  Widget get padVertical4 => pad(AppSpacing.verticalXs4);
  Widget get padVertical8 => pad(AppSpacing.verticalSm8);
  Widget get padVertical12 => pad(AppSpacing.verticalMd12);
  Widget get padVertical16 => pad(AppSpacing.verticalMd16);
  Widget get padVertical24 => pad(AppSpacing.verticalLg24);
  Widget get padVertical32 => pad(AppSpacing.verticalXl32);

  // Preset all sides padding shortcuts
  Widget get padAll4 => pad(AppSpacing.allXs4);
  Widget get padAll8 => pad(AppSpacing.allSm8);
  Widget get padAll12 => pad(AppSpacing.allMd12);
  Widget get padAll16 => pad(AppSpacing.allMd16);
  Widget get padAll24 => pad(AppSpacing.allLg24);
  Widget get padAll32 => pad(AppSpacing.allXl32);

  // ═══════════════════════════════════════════════════════════════
  // MARGIN EXTENSIONS (via Container)
  // ═══════════════════════════════════════════════════════════════

  /// Adds custom margin using EdgeInsets
  ///
  /// Example:
  /// ```dart
  /// Text('Custom').margin(EdgeInsets.only(left: 20, top: 10))
  /// ```
  Widget margin(EdgeInsets margin) => Container(
        margin: margin,
        child: this,
      );

  // Preset horizontal margin shortcuts
  Widget get marginHorizontal4 => margin(AppSpacing.horizontalXs4);
  Widget get marginHorizontal8 => margin(AppSpacing.horizontalSm8);
  Widget get marginHorizontal12 => margin(AppSpacing.horizontalMd12);
  Widget get marginHorizontal16 => margin(AppSpacing.horizontalMd16);
  Widget get marginHorizontal24 => margin(AppSpacing.horizontalLg24);
  Widget get marginHorizontal32 => margin(AppSpacing.horizontalXl32);

  // Preset vertical margin shortcuts
  Widget get marginVertical4 => margin(AppSpacing.verticalXs4);
  Widget get marginVertical8 => margin(AppSpacing.verticalSm8);
  Widget get marginVertical12 => margin(AppSpacing.verticalMd12);
  Widget get marginVertical16 => margin(AppSpacing.verticalMd16);
  Widget get marginVertical24 => margin(AppSpacing.verticalLg24);
  Widget get marginVertical32 => margin(AppSpacing.verticalXl32);

  // Preset all sides margin shortcuts
  Widget get marginAll4 => margin(AppSpacing.allXs4);
  Widget get marginAll8 => margin(AppSpacing.allSm8);
  Widget get marginAll12 => margin(AppSpacing.allMd12);
  Widget get marginAll16 => margin(AppSpacing.allMd16);
  Widget get marginAll24 => margin(AppSpacing.allLg24);
  Widget get marginAll32 => margin(AppSpacing.allXl32);


  // ═══════════════════════════════════════════════════════════════
  // BOX DECORATION
  // ════════════════════════════

  /// Wraps widget in a decorative box with customizable styling
  ///
  /// Uses DecoratedBox for high performance (faster than ClipRRect + Container).
  /// Perfect for chat bubbles, cards, and styled containers.
  ///
  /// ⚠️ IMPORTANT: Does NOT clip child content. Border radius is visual only.
  /// For images or overflow clipping, use .clipRadius8/.clipRadius12/.clipRadius16 instead.
  ///
  /// Example:
  /// ```dart
  /// Text/styled containers (no clipping needed)
  /// Text('Hello').box(
  ///   color: Colors.white,
  ///   radius: 12,
  ///   padding: AppSpacing.allMd16,
  ///   shadow: true,
  /// )
  ///
  /// Images will NOT clip corners
  /// Image.network(url).box(radius: 12)  // corners will overflow!
  ///
  /// Use clipRadius for images
  /// Image.network(url).clipRadius12
  /// ```
  ///
  /// ⚠️ Production Note: Avoid using `shadow: true` in ListView/GridView items
  /// as it can affect scroll performance. Use shadows only for cards, dialogs, headers.
  Widget box({
    Color? color,
    double? radius,
    BorderRadius? borderRadius,
    Border? border,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    AlignmentGeometry? alignment,
    Gradient? gradient,
    bool shadow = false,
    List<BoxShadow>? customShadow,
    Color? shadowColor,
  }) {
    // Apply padding first (wraps child)
    final Widget result = Padding(
      padding: padding ?? EdgeInsets.zero,
      child: this,
    );

    // Apply decoration around padded child
    Widget decorated = DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: borderRadius ?? (radius != null ? BorderRadius.circular(radius) : null),
        border: border,
        boxShadow: customShadow ??
            (shadow
                ? [
                    BoxShadow(
                      color: (shadowColor ?? const Color(0xFF000000)).withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null),
      ),
      child: result,
    );

    // Apply size constraints if provided
    if (width != null || height != null) {
      decorated = SizedBox(
        width: width,
        height: height,
        child: decorated,
      );
    }

    // Apply alignment if provided
    if (alignment != null) {
      decorated = Align(
        alignment: alignment,
        child: decorated,
      );
    }

    // Apply margin (outermost layer)
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: decorated,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CLIPPING (for images and overflow content)
  // ═══════════════════════════════════════════════════════════════

  /// Clips widget with 8px rounded corners (common for small images/avatars)
  /// Performance Cost: Uses ClipRRect (layer clipping). Use sparingly.
  Widget get clipRadius8 => ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm8),
        child: this,
      );

  /// Clips widget with 12px rounded corners (common for cards/images)
  /// Performance Cost: Uses ClipRRect (layer clipping). Use sparingly.
  Widget get clipRadius12 => ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md12),
        child: this,
      );

  /// Clips widget with 16px rounded corners (common for large cards)
  /// Performance Cost: Uses ClipRRect (layer clipping). Use sparingly.
  Widget get clipRadius16 => ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg16),
        child: this,
      );

  /// Clips widget with 24px rounded corners (common for large cards)
  /// Performance Cost: Uses ClipRRect (layer clipping). Use sparingly.
  Widget get clipRadius24 => ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl24),
        child: this,
      );

  // ═══════════════════════════════════════════════════════════════
  // ALIGN HELPERS
  // ═══════════════════════════════════════════════════════════════

  /// Centers the widget within its parent using `Align`.
  Widget get alignCentered => Align(child: this);

  /// Top row alignments
  Widget get alignTopLeft => Align(alignment: Alignment.topLeft, child: this);
  Widget get alignTopCenter => Align(alignment: Alignment.topCenter, child: this);
  Widget get alignTopRight => Align(alignment: Alignment.topRight, child: this);

  /// Middle row alignments
  Widget get alignCenterLeft => Align(alignment: Alignment.centerLeft, child: this);
  Widget get alignCenterRight => Align(alignment: Alignment.centerRight, child: this);

  /// Bottom row alignments
  Widget get alignBottomLeft => Align(alignment: Alignment.bottomLeft, child: this);
  Widget get alignBottomCenter => Align(alignment: Alignment.bottomCenter, child: this);
  Widget get alignBottomRight => Align(alignment: Alignment.bottomRight, child: this);

  /// Directional alignments (useful for RTL-aware layouts)
  Widget get alignTopStart => Align(alignment: AlignmentDirectional.topStart, child: this);
  Widget get alignTopEnd => Align(alignment: AlignmentDirectional.topEnd, child: this);
  Widget get alignCenterStart => Align(alignment: AlignmentDirectional.centerStart, child: this);
  Widget get alignCenterEnd => Align(alignment: AlignmentDirectional.centerEnd, child: this);
  Widget get alignBottomStart => Align(alignment: AlignmentDirectional.bottomStart, child: this);
  Widget get alignBottomEnd => Align(alignment: AlignmentDirectional.bottomEnd, child: this);

  // ═══════════════════════════════════════════════════════════════
  // GESTURES
  // ═══════════════════════════════════════════════════════════════

  /// Adds tap gesture to widget
  ///
  /// Uses `deferToChild` behavior by default (safer for nested gestures).
  /// Set `behavior: HitTestBehavior.opaque` if you need transparent areas to be tappable.
  ///
  /// Example:
  /// ```dart
  /// Text('Click me').onTap(() => print('Tapped!'))
  ///
  /// For transparent tap zones
  /// Container(width: 100, height: 100).onTap(
  ///   () => print('Tapped'),
  ///   behavior: HitTestBehavior.opaque,
  /// )
  /// ```
  Widget onTap(
    VoidCallback onTap, {
    HitTestBehavior? behavior,
  }) =>
      GestureDetector(
        onTap: onTap,
        behavior: behavior ?? HitTestBehavior.deferToChild,
        child: this,
      );

  /// Adds Material InkWell tap gesture with ripple effect
  ///
  /// Use when inside Material widget for visual feedback.
  /// Provides accessibility hints and Material Design ripple.
  ///
  /// Example:
  /// ```dart
  /// Text('Click me').onTapInk(() => print('Tapped!'))
  ///
  /// With custom ripple color
  /// Text('Click me').onTapInk(
  ///   () => print('Tapped'),
  ///   splashColor: Colors.blue.withValues(alpha: 0.3),
  ///   borderRadius: BorderRadius.circular(12),
  /// )
  /// ```
  Widget onTapInk(
    VoidCallback onTap, {
    Color? splashColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
  }) =>
      InkWell(
        onTap: onTap,
        splashColor: splashColor,
        highlightColor: highlightColor,
        borderRadius: borderRadius,
        child: this,
      );

  // ═══════════════════════════════════════════════════════════════
  // BACKGROUND & STYLING
  // ═══════════════════════════════════════════════════════════════

  /// Wraps widget with a background color
  ///
  /// Example:
  /// ```dart
  /// Text('Hello').withBackground(Colors.blue)
  /// ```
  Widget withBackground(Color color) => ColoredBox(
        color: color,
        child: this,
      );

  // ═══════════════════════════════════════════════════════════════
  // SCROLLABLE
  // ═══════════════════════════════════════════════════════════════

  /// Makes widget scrollable
  ///
  /// ⚠️ Production Warning: Do NOT use inside ListView, GridView, or other scrollable.
  /// This creates a SingleChildScrollView which will conflict with parent scroll widgets.
  ///
  /// ✅ Use for: Page-level wrappers, non-scrollable parent containers
  /// ❌ Avoid: Inside ListView.builder, GridView, CustomScrollView
  ///
  /// Example:
  /// ```dart
  /// ✅ Correct - page-level scroll
  /// Column(children: [...]).scrollable()
  ///
  /// ❌ Wrong - nested scroll conflict
  /// ListView(
  ///   children: [
  ///     Column(...).scrollable()  // Will cause issues!
  ///   ]
  /// )
  /// ```
  Widget scrollable({
    ScrollPhysics? physics,
    EdgeInsets? padding,
    ScrollController? controller,
  }) =>
      SingleChildScrollView(
        physics: physics,
        padding: padding,
        controller: controller,
        child: this,
      );
}
