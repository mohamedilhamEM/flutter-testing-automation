import 'package:flutter/material.dart';
import 'package:testingapp/utils/utils.dart';

/// Defines the size variants for the buttons.
enum CommonButtonSize {
  /// Small button: fixed width 220px (standard across TRP-L projects).
  small,

  /// Large button: uses theme default (typically full width).
  large,
}

// ═══════════════════════════════════════════════════════════════
// COMMON BUTTON FACADE
// ═══════════════════════════════════════════════════════════════

/// The primary entry point for all buttons in the application.
///
/// This class follows the **Facade Pattern**—it provides a simple, consolidated API
/// (`CommonButton.primary`, `CommonButton.outline`, `CommonButton.text`) while
/// delegating the actual rendering to dedicated single-responsibility widgets
/// (`_PrimaryButton`, `_OutlineButton`, `_GhostButton`).
///
/// This approach provides **Great Developer Experience (DX)** while maintaining
/// **SOLID Principles** internally.
abstract class CommonButton {
  /// Creates a Primary (Elevated) button.
  /// Automatically inherits styling from [ThemeData.elevatedButtonTheme].
  static Widget primary({
    required VoidCallback? onPressed,
    String? label,
    Widget? child,
    bool isLoading = false,
    bool isEnabled = true,
    CommonButtonSize size = CommonButtonSize.large,
    Size? minimumSize,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _PrimaryButton(
      key: key,
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      isEnabled: isEnabled,
      size: size,
      minimumSize: minimumSize,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textStyle: textStyle,
      child: child,
    );
  }

  /// Creates an Outlined (Secondary) button.
  /// Automatically inherits styling from [ThemeData.outlinedButtonTheme].
  static Widget outline({
    required VoidCallback? onPressed,
    String? label,
    Widget? child,
    bool isLoading = false,
    bool isEnabled = true,
    CommonButtonSize size = CommonButtonSize.large,
    Size? minimumSize,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _OutlineButton(
      key: key,
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      isEnabled: isEnabled,
      size: size,
      minimumSize: minimumSize,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textStyle: textStyle,
      child: child,
    );
  }

  /// Creates a Text button.
  /// Automatically inherits styling from [ThemeData.textButtonTheme].
  static Widget text({
    required VoidCallback? onPressed,
    String? label,
    Widget? child,
    bool isLoading = false,
    bool isEnabled = true,
    CommonButtonSize size = CommonButtonSize.large,
    Size? minimumSize,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    Key? key,
  }) {
    return _GhostButton(
      key: key,
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      isEnabled: isEnabled,
      size: size,
      minimumSize: minimumSize,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textStyle: textStyle,
      child: child,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// INTERNAL IMPLEMENTATIONS (SOLID - SRP)
// ═══════════════════════════════════════════════════════════════

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.onPressed,
    this.label,
    this.child,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = CommonButtonSize.large,
    this.minimumSize,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    super.key,
  });

  final VoidCallback? onPressed;
  final String? label;
  final Widget? child;
  final bool isLoading;
  final bool isEnabled;
  final CommonButtonSize size;
  final Size? minimumSize;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;

  static final double _smallWidth = 220.w;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final effectiveForeground = foregroundColor ?? colorScheme.onPrimary;

    Widget button = ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        textStyle: textStyle,
      ).copyWith(
        minimumSize: (minimumSize != null || size == CommonButtonSize.small) ? WidgetStatePropertyAll(minimumSize ?? Size(_smallWidth, 48)) : null,
      ),
      child: _ButtonContent(
        isLoading: isLoading,
        spinnerColor: effectiveForeground,
        iconColor: effectiveForeground,
        label: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        child: child,
      ),
    );

    if (isLoading) {
      button = AbsorbPointer(child: button);
    }

    return button;
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    required this.onPressed,
    this.label,
    this.child,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = CommonButtonSize.large,
    this.minimumSize,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    super.key,
  });

  final VoidCallback? onPressed;
  final String? label;
  final Widget? child;
  final bool isLoading;
  final bool isEnabled;
  final CommonButtonSize size;
  final Size? minimumSize;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;

  static final double _smallWidth = 220.w;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final effectiveForeground = foregroundColor ?? colorScheme.primary;

    Widget button = OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        textStyle: textStyle,
      ).copyWith(
        minimumSize: (minimumSize != null || size == CommonButtonSize.small) ? WidgetStatePropertyAll(minimumSize ?? Size(_smallWidth, 48)) : null,
      ),
      child: _ButtonContent(
        isLoading: isLoading,
        spinnerColor: effectiveForeground,
        iconColor: effectiveForeground,
        label: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        child: child,
      ),
    );

    if (isLoading) {
      button = AbsorbPointer(child: button);
    }

    return button;
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({
    required this.onPressed,
    this.label,
    this.child,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = CommonButtonSize.large,
    this.minimumSize,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    super.key,
  });

  final VoidCallback? onPressed;
  final String? label;
  final Widget? child;
  final bool isLoading;
  final bool isEnabled;
  final CommonButtonSize size;
  final Size? minimumSize;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final effectiveForeground = foregroundColor ?? colorScheme.primary;

    Widget button = TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        textStyle: textStyle,
      ).copyWith(
        minimumSize: (minimumSize != null || size == CommonButtonSize.small) ? WidgetStatePropertyAll(minimumSize ?? Size(220.w, 48)) : null,
      ),
      child: _ButtonContent(
        isLoading: isLoading,
        spinnerColor: effectiveForeground,
        iconColor: effectiveForeground,
        label: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        child: child,
      ),
    );

    if (isLoading) {
      button = AbsorbPointer(child: button);
    }

    return button;
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.isLoading,
    required this.spinnerColor,
    this.label,
    this.child,
    this.prefixIcon,
    this.suffixIcon,
    this.iconColor,
  });

  final bool isLoading;
  final Color spinnerColor;
  final String? label;
  final Widget? child;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? iconColor;

  static const double _iconSize = 18;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: _iconSize,
        width: _iconSize,
        child: CommonCircularLoader(color: spinnerColor),
      );
    }

    if (child != null) return child!;

    if (prefixIcon == null && suffixIcon == null) {
      return Text(label ?? '');
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          Icon(prefixIcon, size: _iconSize, color: iconColor),
          Gaps.gapSm8,
        ],
        Text(label ?? ''),
        if (suffixIcon != null) ...[
          Gaps.gapSm8,
          Icon(suffixIcon, size: _iconSize, color: iconColor),
        ],
      ],
    );
  }
}
