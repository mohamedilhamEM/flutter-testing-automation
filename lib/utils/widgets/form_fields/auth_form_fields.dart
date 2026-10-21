import 'package:check_disposable_email/check_disposable_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/utils/utils.dart' hide Disposable;

/// A utility class for creating authentication-related form fields.
///
/// Use as:
/// ```dart
/// AuthFormFields.email(controller: _emailController)
/// AuthFormFields.password(controller: _passwordController)
/// AuthFormFields.password(controller: _passwordController, showStrengthIndicator: true)
/// ```
class AuthFormFields {
  const AuthFormFields._();

  /// Creates an email form field with validation and password manager autofill support.
  static Widget email({
    required TextEditingController controller,
    String? hintText,
    String? title,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    Iterable<String>? autofillHints = const [
      AutofillHints.username,
      AutofillHints.email,
    ],
  }) {
    return _EmailFormField(
      controller: controller,
      hintText: hintText,
      title: title,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: autovalidateMode,
      textInputAction: textInputAction,
      focusNode: focusNode,
      autofillHints: autofillHints,
    );
  }

  /// Creates a password form field with visibility toggle and autofill support.
  ///
  /// Set [showStrengthIndicator] to true to show a password strength meter.
  /// Set [requireStrict] to true (default) to enforce uppercase, lowercase, and numbers.
  /// [autofillHints] defaults to `[AutofillHints.password]`. For sign-up forms,
  /// pass `[AutofillHints.newPassword]`.
  static Widget password({
    required TextEditingController controller,
    String? hintText,
    String? title,
    String? Function(String?)? validator,
    int minLength = 8,
    int maxLength = 128,
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    bool showStrengthIndicator = false,
    bool requireStrict = true,
    Iterable<String>? autofillHints = const [AutofillHints.password],
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  }) {
    return _PasswordFormField(
      controller: controller,
      hintText: hintText,
      title: title,
      validator: validator,
      minLength: minLength,
      maxLength: maxLength,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      showStrengthIndicator: showStrengthIndicator,
      requireStrict: requireStrict,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      focusNode: focusNode,
    );
  }
}

/// A specialized text field for email input with built-in validation.
class _EmailFormField extends StatelessWidget {
  /// Creates an email form field.
  const _EmailFormField({
    required this.controller,
    this.hintText,
    this.title,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.textInputAction,
    this.focusNode,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? title;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final AutovalidateMode autovalidateMode;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;

  String? _emailValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.errorEnterEmail;
    }

    // Basic email format validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return context.l10n.errorInvalidEmailAddress;
    }

    // Check for disposable email domains using check_disposable_email package
    final result = Disposable.instance.validateEmail(value);
    if (result.isDisposable) {
      return context.l10n.disposableEmailError;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      controller: controller,
      hintText: hintText ?? context.l10n.enterEmailHint,
      title: title,
      validator: validator ?? (value) => _emailValidator(context, value),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: autovalidateMode,
      textInputAction: textInputAction ?? TextInputAction.next,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      autofillHints: autofillHints,
    );
  }
}

/// A specialized text field for password input with visibility toggle.
class _PasswordFormField extends StatefulWidget {
  const _PasswordFormField({
    required this.controller,
    this.hintText,
    this.title,
    this.validator,
    this.minLength = 8,
    this.maxLength = 128,
    this.onChanged,
    this.onFieldSubmitted,
    this.showStrengthIndicator = false,
    this.requireStrict = true,
    this.autofillHints,
    this.textInputAction,
    this.focusNode,
  })  : assert(minLength > 0, 'minLength must be positive'),
        assert(maxLength > minLength, 'maxLength must be greater than minLength');

  final TextEditingController controller;
  final String? hintText;
  final String? title;
  final String? Function(String?)? validator;
  final int minLength;
  final int maxLength;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool showStrengthIndicator;
  final bool requireStrict;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  @override
  State<_PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<_PasswordFormField> {
  bool _isVisible = false;
  PasswordStrength _strength = PasswordStrength.weak;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _onPasswordChanged(String value) {
    if (widget.showStrengthIndicator) {
      setState(() {
        _strength = _calculatePasswordStrength(value);
      });
    }
    widget.onChanged?.call(value);
  }

  PasswordStrength _calculatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    var score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety
    if (password.contains(RegExp('[A-Z]'))) score++; // Uppercase
    if (password.contains(RegExp('[a-z]'))) score++; // Lowercase
    if (password.contains(RegExp('[0-9]'))) score++; // Numbers
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++; // Special chars

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  String? _passwordValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.pleaseEnterPassword;
    }

    // Check for whitespace
    if (value.contains(' ')) {
      return context.l10n.passwordNoSpacesError;
    }

    if (value.length < widget.minLength) {
      return context.l10n.passwordMinLengthError(widget.minLength);
    }

    // Check max length
    if (value.length > widget.maxLength) {
      return context.l10n.passwordMaxLengthError(widget.maxLength);
    }

    // Apply strict validation only when required (e.g., sign-up)
    if (widget.requireStrict) {
      final hasLetter = value.contains(RegExp('[a-zA-Z]'));
      final hasDigit = value.contains(RegExp('[0-9]'));

      if (!hasLetter || !hasDigit) {
        return context.l10n.passwordMustContainLettersAndDigits;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextField(
          controller: widget.controller,
          hintText: widget.hintText ?? context.l10n.enterPassword,
          title: widget.title,
          obscureText: !_isVisible,
          validator: widget.validator ?? (value) => _passwordValidator(context, value),
          onChanged: _onPasswordChanged,
          keyboardType: TextInputType.visiblePassword,
          autofillHints: widget.autofillHints,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onFieldSubmitted,
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.maxLength),
          ],
          suffixIcon: IconButton(
            icon: Icon(
              _isVisible ? Icons.visibility : Icons.visibility_off,
              color: colorScheme.primary,
            ),
            onPressed: _toggleVisibility,
          ),
        ),
        if (widget.showStrengthIndicator && widget.controller.text.isNotEmpty) ...[
          Gaps.gapSm8,
          _PasswordStrengthIndicator(strength: _strength),
        ],
      ],
    );
  }
}

/// Enum representing password strength levels
enum PasswordStrength {
  weak,
  medium,
  strong,
}

/// Widget that displays password strength visually
class _PasswordStrengthIndicator extends StatelessWidget {
  const _PasswordStrengthIndicator({required this.strength});

  final PasswordStrength strength;

  @override
  Widget build(BuildContext context) {
    final colors = _getStrengthColors(context);
    final text = _getStrengthText(context);
    final trackColor = context.themeColors.passwordTrackColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: colors.$1,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: strength == PasswordStrength.weak ? trackColor : colors.$1,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: strength == PasswordStrength.strong ? colors.$1 : trackColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: context.bodySmall(color: colors.$2).medium,
        ),
      ],
    );
  }

  (Color, Color) _getStrengthColors(BuildContext context) {
    switch (strength) {
      case PasswordStrength.weak:
        return (context.themeColors.passwordWeakColor, context.themeColors.passwordWeakColor);
      case PasswordStrength.medium:
        return (context.themeColors.passwordMediumColor, context.themeColors.passwordMediumColor);
      case PasswordStrength.strong:
        return (context.themeColors.passwordStrongColor, context.themeColors.passwordStrongColor);
    }
  }

  /// Returns localized password strength text.
  String _getStrengthText(BuildContext context) {
    switch (strength) {
      case PasswordStrength.weak:
        return context.l10n.passwordStrengthWeak;
      case PasswordStrength.medium:
        return context.l10n.passwordStrengthMedium;
      case PasswordStrength.strong:
        return context.l10n.passwordStrengthStrong;
    }
  }
}
