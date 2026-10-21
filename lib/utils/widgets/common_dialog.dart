import 'package:flutter/material.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/utils/utils.dart';

/// A utility class for showing common dialogs.
///
/// ## Usage
/// ```dart
/// Confirmation dialog
/// final confirmed = await CommonDialog.confirm(
///   context,
///   title: 'Delete Item',
///   message: 'Are you sure you want to delete this item?',
/// );
///
/// Alert dialog
/// await CommonDialog.alert(
///   context,
///   title: 'Error',
///   message: 'Something went wrong.',
/// );
///
/// Custom actions
/// await CommonDialog.actions(
///   context,
///   title: 'Choose',
///   message: 'Select an option',
///   actions: [
///     DialogAction(text: 'Option 1', onPressed: () => Navigator.pop(context)),
///     DialogAction(text: 'Option 2', onPressed: () => Navigator.pop(context), isDestructive: true),
///   ],
/// );
/// ```
class CommonDialog {
  CommonDialog._();

  /// Shows a confirmation dialog with Yes/No buttons.
  ///
  /// Returns `true` if confirmed, `false` if cancelled.
  ///
  /// [confirmColor] defaults to theme primary (or error if [isDangerous] is true).
  /// [cancelColor] defaults to theme onSurfaceVariant.
  static Future<bool> confirm(
    BuildContext context, {
    required String message,
    String title = 'Confirm',
    String? confirmText,
    String? cancelText,
    bool isDangerous = false,
    Color? confirmColor,
    Color? cancelColor,
  }) async {
    final effectiveConfirmColor = confirmColor ?? (isDangerous ? context.colorScheme.error : context.colorScheme.primary);
    final effectiveCancelColor = cancelColor ?? context.colorScheme.onSurfaceVariant;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(title),
        content: Text(message),
        actions: [
          CommonButton.text(
            textStyle: context.alertDialogButton(),
            onPressed: () => Navigator.of(context).pop(false),
            foregroundColor: effectiveCancelColor,
            label: cancelText ?? context.l10n.no,
          ),
          CommonButton.text(
            textStyle: context.alertDialogButton(),
            onPressed: () => Navigator.of(context).pop(true),
            foregroundColor: effectiveConfirmColor,
            label: confirmText ?? context.l10n.yes,            
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Shows a simple alert dialog with an OK button.
  ///
  /// The dialog is not dismissible by tapping outside - user must tap the button.
  /// Colors automatically adapt to the current theme (light/dark mode).
  ///
  /// [buttonColor] defaults to theme primary. Pass a custom color to override.
  /// [onPressed] callback is executed after the dialog is dismissed.
  static Future<void> alert(
    BuildContext context, {
    required String message,
    String title = 'Alert',
    String? buttonText,
    Color? buttonColor,
    VoidCallback? onPressed,
  }) async {
    final effectiveButtonColor = buttonColor ?? context.colorScheme.primary;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog.adaptive(
        title: Text(title),
        content: Text(message),
        actions: [
          CommonButton.text(
            textStyle: context.alertDialogButton(),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed?.call();
            },
            foregroundColor: effectiveButtonColor,
            label: buttonText ?? context.l10n.ok,
          ),
        ],
      ),
    );
  }

  /// Shows a dialog with custom content.
  ///
  /// Supports both [Widget] actions and [DialogAction] for more control.
  static Future<T?> custom<T>(
    BuildContext context, {
    required String title,
    required Widget content,
    List<Widget>? actions,
    List<DialogAction>? dialogActions,
  }) async {
    return showDialog<T>(
      context: context,
      builder: (dialogContext) => AlertDialog.adaptive(
        title: Text(title),
        content: content,
        actions: dialogActions != null
            ? dialogActions
                .map(
                  (action) => CommonButton.text(
                    textStyle: context.alertDialogButton(),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      action.onPressed();
                    },
                    foregroundColor: action.isDestructive ? dialogContext.colorScheme.error : action.textColor ?? dialogContext.colorScheme.primary,
                    label: action.text,
                  ),
                )
                .toList()
            : actions,
      ),
    );
  }

  /// Shows a dialog with multiple action buttons.
  ///
  /// More flexible than [confirm] - supports multiple custom actions.
  static Future<T?> actions<T>(
    BuildContext context, {
    required String title,
    required String message,
    required List<DialogAction> actions,
    bool barrierDismissible = true,
  }) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => AlertDialog.adaptive(
        title: Text(title),
        content: Text(message),
        actions: actions
            .map(
              (action) => CommonButton.text(
                textStyle: context.alertDialogButton(),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  action.onPressed();
                },
                foregroundColor: action.isDestructive ? dialogContext.colorScheme.error : action.textColor ?? dialogContext.colorScheme.primary,
                label: action.text,
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Represents a dialog action button with customization options.
///
/// Use this class with [CommonDialog.custom] or [CommonDialog.actions] for more control.
class DialogAction {
  const DialogAction({
    required this.text,
    required this.onPressed,
    this.textColor,
    this.isDestructive = false,
  });

  /// The text to display on the button
  final String text;

  /// Callback when the button is pressed
  final VoidCallback onPressed;

  /// Custom color for the button text (optional)
  final Color? textColor;

  /// Whether this action is destructive (will use error color if true)
  final bool isDestructive;
}
