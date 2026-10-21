import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/utils/utils.dart';

/// The foundational text field widget following Atomic Design principles.
///
/// This is the **Atom** — the smallest, most basic form input component.
/// All specialized text fields (Password, Stepper, Description) are built
/// on top of this base widget using composition.
///
/// ## Design Philosophy
/// - **Single Responsibility**: Only handles core text input styling
/// - **Theme-Aware**: Uses [InputDecorationTheme] for consistent styling
/// - **Composable**: Specialized fields wrap this widget, not extend it
///
/// ## Example Usage
/// ```dart
/// CommonTextField(
///   controller: _emailController,
///   hintText: 'Enter email',
///   title: 'Email Address',
///   keyboardType: TextInputType.emailAddress,
///   validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
/// )
/// ```
class CommonTextField extends StatelessWidget {
  /// Creates a base text field.
  ///
  /// Throws [AssertionError] if [obscureText] is true and [maxLines] is not 1.
  const CommonTextField({
    required this.controller,
    this.hintText,
    super.key,
    this.title,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.alignLabelWithHint,
    this.autofillHints,
  }) : assert(
          !obscureText || maxLines == 1,
          'Obscured text fields must have maxLines = 1',
        );

  /// Controller for the text field value.
  final TextEditingController controller;

  /// Hint text displayed when the field is empty.
  final String? hintText;

  /// Optional label displayed above the text field.
  final String? title;

  /// Widget displayed at the end of the text field.
  final Widget? suffixIcon;

  /// Widget displayed at the start of the text field.
  final Widget? prefixIcon;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// The type of keyboard to display.
  final TextInputType? keyboardType;

  /// The action button on the keyboard.
  final TextInputAction? textInputAction;

  /// Input formatters to apply.
  final List<TextInputFormatter>? inputFormatters;

  /// Validation function.
  final String? Function(String?)? validator;

  /// Callback when text changes.
  final void Function(String)? onChanged;

  /// Callback when field is tapped.
  final VoidCallback? onTap;

  /// Callback when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Callback when user submits (presses done/next on keyboard).
  ///
  /// Useful for navigating to the next field in a form.
  final void Function(String)? onFieldSubmitted;

  /// When to validate automatically.
  final AutovalidateMode autovalidateMode;

  /// Maximum number of lines.
  final int? maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Maximum character length.
  final int? maxLength;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether the field is enabled.
  final bool enabled;

  /// Focus node for keyboard focus control.
  final FocusNode? focusNode;

  /// Whether to autofocus this field.
  final bool autofocus;

  /// Text capitalization mode.
  final TextCapitalization textCapitalization;

  /// Whether to align the label with the hint text in multiline fields.
  final bool? alignLabelWithHint;

  /// The autofill hints for this field (e.g., [AutofillHints.email], [AutofillHints.password]).
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title label
        if (title != null) _buildTitle(theme, context),

        // Text field attempting to animate the fill color smoothy
        TweenAnimationBuilder<Color?>(
          duration: kThemeAnimationDuration,
          tween: ColorTween(end: theme.inputDecorationTheme.fillColor ?? Colors.transparent),
          builder: (context, animatedColor, child) {
            return TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              validator: validator,
              onChanged: onChanged,
              onTap: onTap,
              onEditingComplete: onEditingComplete,
              onFieldSubmitted: onFieldSubmitted,
              autovalidateMode: autovalidateMode,
              maxLines: obscureText ? 1 : maxLines,
              minLines: minLines,
              maxLength: maxLength,
              readOnly: readOnly,
              enabled: enabled,
              focusNode: focusNode,
              autofocus: autofocus,
              autofillHints: autofillHints,
              textCapitalization: textCapitalization,
              decoration: InputDecoration(
                hintText: hintText ?? '',
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                fillColor: animatedColor,
                alignLabelWithHint: alignLabelWithHint,
              ),
            );
          },
        ),
      ],
    );
  }

  /// Builds the title label widget.
  Widget _buildTitle(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: context.formLabel(),
        ),
        Gaps.gapSm8,
      ],
    );
  }

  /// Creates a multi-line description text field.
  static Widget description({
    required TextEditingController controller,
    String? hintText,
    String? title,
    int minLines = 3,
    int? maxLines,
    int? maxLength,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    bool enabled = true,
    FocusNode? focusNode,
  }) {
    return _DescriptionTextField(
      controller: controller,
      hintText: hintText,
      title: title,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      enabled: enabled,
      focusNode: focusNode,
    );
  }

  /// Creates a numeric text field.
  static Widget number({
    required TextEditingController controller,
    String? hintText,
    String? title,
    bool decimal = false,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    bool enabled = true,
  }) {
    return _NumberTextField(
      controller: controller,
      hintText: hintText,
      title: title,
      decimal: decimal,
      validator: validator,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      textInputAction: textInputAction,
      focusNode: focusNode,
      enabled: enabled,
    );
  }
}

/// A specialized numeric text field.
class _NumberTextField extends StatelessWidget {
  const _NumberTextField({
    required this.controller,
    this.hintText,
    this.title,
    this.decimal = false,
    this.validator,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.textInputAction,
    this.focusNode,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? title;
  final bool decimal;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final AutovalidateMode autovalidateMode;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      controller: controller,
      hintText: hintText ?? context.l10n.enterDigitsOnly,
      title: title,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      inputFormatters: [
        if (decimal) FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')) else FilteringTextInputFormatter.digitsOnly,
      ],
      validator: validator,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      textInputAction: textInputAction,
      focusNode: focusNode,
      enabled: enabled,
    );
  }
}

/// A specialized multi-line text field for longer text input.
class _DescriptionTextField extends StatelessWidget {
  /// Creates a description form field.
  const _DescriptionTextField({
    required this.controller,
    this.hintText,
    this.title,
    this.minLines = 3,
    this.maxLines,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.enabled = true,
    this.focusNode,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? title;
  final int minLines;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final AutovalidateMode autovalidateMode;
  final bool enabled;
  final FocusNode? focusNode;

  String? Function(String?) _buildValidator(BuildContext context) {
    return (value) {
      if (maxLength != null && (value?.length ?? 0) > maxLength!) {
        return context.l10n.maxLengthError(maxLength ?? 0);
      }

      return validator?.call(value);
    };
  }

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      controller: controller,
      title: title,
      hintText: hintText ?? context.l10n.enterDescription,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: _buildValidator(context),
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      enabled: enabled,
      focusNode: focusNode,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      alignLabelWithHint: true,
    );
  }
}
