import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/utils/utils.dart';

/// A specialized form field for phone number input with country code picker.
///
/// This widget provides a complete phone number input solution following
/// the Atomic Design pattern as a Molecule component.
///
/// ## Features
/// - 📱 Country code picker with search functionality
/// - 🔢 Numeric-only input with length limiting
/// - ✅ Built-in and custom validation support
/// - 🎨 Fully theme-aware design
/// - 🌍 Favorite countries support
///
/// ## Example Usage
/// ```dart
/// PhoneFormField(
///   phoneNumberController: _phoneController,
///   phoneFocusNode: _phoneFocusNode,
///   title: 'Phone Number',
///   initialCountryCode: '+1',
///   onCountryCodeChanged: (code) => setState(() => _countryCode = code),
///   onChanged: (value) => print('Phone: $value'),
///   phoneNumberValidator: (value) {
///     if (value == null || value.length < 10) {
///       return 'Please enter a valid phone number';
///     }
///     return null;
///   },
/// )
/// ```
///
/// ## Why Separate Widget?
/// Phone input has unique requirements:
/// - Country code selection
/// - Phone-specific formatting
/// - E.164 format considerations
///
/// ## References
/// - [country_picker](https://pub.dev/packages/country_picker)
/// - [E.164 Phone Format](https://en.wikipedia.org/wiki/E.164)
///
/// See also:
/// - [CommonTextField] for general text input.
/// - [AuthFormFields.password] for password inputs.
class PhoneFormField extends StatefulWidget {
  /// Creates a phone number input field with country code picker.
  ///
  /// [maxPhoneLength] must be positive and greater than [minPhoneLength].
  const PhoneFormField({
    required this.phoneNumberController,
    required this.phoneFocusNode,
    super.key,
    this.title,
    this.initialCountryCode = '+61',
    this.phoneNumberValidator,
    this.phoneNumberHintText = 'Enter phone number',
    this.onCountryCodeChanged,
    this.onChanged,
    this.favoriteCountries = const ['AU'],
    this.maxPhoneLength = 13,
    this.minPhoneLength = 6,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.autofillHints = const [AutofillHints.telephoneNumber],
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
  })  : assert(maxPhoneLength > 0, 'maxPhoneLength must be positive'),
        assert(
          minPhoneLength >= 0 && minPhoneLength <= maxPhoneLength,
          'minPhoneLength must be between 0 and maxPhoneLength',
        );

  /// Controller for the phone number text field.
  final TextEditingController phoneNumberController;

  /// Focus node for managing keyboard focus.
  final FocusNode phoneFocusNode;

  /// Optional label displayed above the field.
  final String? title;

  /// Initial country code to display (e.g., '+61' for Australia).
  ///
  /// Must include the '+' prefix.
  final String initialCountryCode;

  /// Custom validator for the phone number field.
  ///
  /// If null, a default validator is used that checks:
  /// - Non-empty input
  /// - Digits only
  /// - Minimum length
  final String? Function(String?)? phoneNumberValidator;

  /// Hint text displayed when the field is empty.
  final String phoneNumberHintText;

  /// Callback fired when the country code is changed.
  final void Function(String)? onCountryCodeChanged;

  /// Callback fired when the phone number text changes.
  final void Function(String)? onChanged;

  /// List of ISO country codes to show as favorites.
  ///
  /// These countries appear at the top of the picker.
  /// Example: `['US', 'GB', 'AU']`
  final List<String> favoriteCountries;

  /// Maximum length for phone number input.
  ///
  /// Defaults to 13 digits to accommodate most international formats.
  final int maxPhoneLength;

  /// Minimum length for a valid phone number.
  ///
  /// Used by the default validator. Defaults to 6.
  final int minPhoneLength;

  /// Whether the field accepts input.
  final bool enabled;

  /// When to validate automatically.
  final AutovalidateMode autovalidateMode;

  /// Optional autofill hints for the phone number field.
  final Iterable<String>? autofillHints;

  /// The action button on the keyboard.
  final TextInputAction textInputAction;

  /// Callback when the user submits from the keyboard.
  final void Function(String)? onFieldSubmitted;

  @override
  State<PhoneFormField> createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends State<PhoneFormField> {
  /// Currently selected country code with '+' prefix.
  late String _countryCode;

  @override
  void initState() {
    super.initState();
    _countryCode = widget.initialCountryCode;
  }

  @override
  void didUpdateWidget(PhoneFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCountryCode != widget.initialCountryCode) {
      _countryCode = widget.initialCountryCode;
    }
  }

  /// Opens the country picker bottom sheet.
  void _showCountryPicker() {
    if (!widget.enabled) return;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showCountryPicker(
      context: context,
      showPhoneCode: true,
      favorite: widget.favoriteCountries,
      onSelect: _onCountrySelected,
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: MediaQuery.sizeOf(context).height * 0.7,
        backgroundColor: colorScheme.surface,
        textStyle: context.bodyDefault(
          color: colorScheme.onSurface,
        ),
        searchTextStyle: context.bodyDefault(
          color: colorScheme.onSurface,
        ),
        inputDecoration: InputDecoration(
          hintText: context.l10n.searchCountry,
          hintStyle: context.bodyDefault(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary),
          ),
        ),
      ),
    );
  }

  /// Handles country selection from the picker.
  void _onCountrySelected(Country country) {
    setState(() {
      _countryCode = '+${country.phoneCode}';
    });
    widget.onCountryCodeChanged?.call(_countryCode);
  }

  /// Default validator for phone number input.
  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.enterContactNumber;
    }

    final numberRegExp = RegExp(r'^[0-9]+$');
    if (!numberRegExp.hasMatch(value)) {
      return context.l10n.enterDigitsOnly;
    }

    if (value.length < widget.minPhoneLength) {
      return context.l10n.phoneNumberTooShort;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;

    final borderColor = inputTheme.enabledBorder?.borderSide.color ?? colorScheme.outline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title label
        if (widget.title != null) _buildTitle(theme),

        Gaps.gapMd16,

        // Phone input row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Code Picker
            _buildCountryCodePicker(
              colorScheme: colorScheme,
              borderColor: borderColor,
            ),
            Gaps.gapMd16,
            // Phone Number Input
            Expanded(
              child: _buildPhoneNumberField(),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the title label widget.
  Widget _buildTitle(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title!,
          style: context.bodyDefault(),
        ),
        Gaps.gapSm8,
      ],
    );
  }

  /// Builds the country code picker button with accessibility support.
  Widget _buildCountryCodePicker({
    required ColorScheme colorScheme,
    required Color borderColor,
  }) {
    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: 'Select country code, current: $_countryCode',
      hint: 'Double tap to open country picker',
      child: GestureDetector(
        onTap: _showCountryPicker,
        child: Container(
          width: 100,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppRadius.allMd12,
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _countryCode,
                    style: context.bodyLarge(
                      color: widget.enabled 
                        ? colorScheme.onSurface 
                        : colorScheme.onSurface.withValues(alpha: 0.38),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  size: 24,
                  color: widget.enabled ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.38),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the phone number text field.
  Widget _buildPhoneNumberField() {
    return TextFormField(
      focusNode: widget.phoneFocusNode,
      controller: widget.phoneNumberController,
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      keyboardType: TextInputType.phone,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      autofillHints: widget.autofillHints,
      onChanged: widget.onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(widget.maxPhoneLength),
      ],
      decoration: InputDecoration(
        errorMaxLines: 2,
        hintText: widget.phoneNumberHintText,
      ),
      validator: widget.phoneNumberValidator ?? _defaultValidator,
    );
  }
}
