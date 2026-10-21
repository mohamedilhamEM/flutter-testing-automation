import 'package:flutter/material.dart';
import 'package:testingapp/utils/utils.dart';

/// Shows a snackbar with the given message.
///
/// This is an extension on [BuildContext] for convenient snackbar display.
///
/// ## Usage
/// ```dart
/// context.showSnackBar('Profile updated!');
///
/// With action
/// context.showSnackBar(
///   'Item deleted',
///   action: SnackBarAction(label: 'Undo', onPressed: () => undo()),
/// );
///
/// Error style
/// context.showErrorSnackBar('Something went wrong');
///
/// Success style
/// context.showSuccessSnackBar('Saved successfully!');
/// ```
extension SnackBarExtension on BuildContext {
  /// Shows a snackbar with the given message.
  void showSnackBar(
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        duration: duration,
        behavior: behavior,
      ),
    );
  }

  /// Shows a success snackbar (green).
  void showSuccessSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: themeColors.onSuccessColor),
            Gaps.gapSm8,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: themeColors.successColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows an error snackbar (red).
  void showErrorSnackBar(
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: colorScheme.onError),
            Gaps.gapSm8,
            Expanded(child: Text(message)),
          ],
        ),
        action: action,
        backgroundColor: colorScheme.error,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows a fully custom snackbar with arbitrary widget content.
  void showCustomSnackBar({
    required Widget content,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    Color? backgroundColor,
    SnackBarAction? action,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: content,
        action: action,
        duration: duration,
        behavior: behavior,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        margin: behavior == SnackBarBehavior.floating ? margin : null,
        padding: padding,
      ),
    );
  }
}
