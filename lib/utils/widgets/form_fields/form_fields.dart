/// Form field components following Atomic Design principles.
///
/// This library provides specialized form field widgets that are built
/// on top of `CommonTextField`, each handling a specific use case.
///
/// ## Architecture: Atomic Design
///
/// ```text
/// Atoms (Base Components)
/// └── BaseTextField — Core styling and shared behavior
///
/// Molecules (Specialized Components)
/// ├── AuthFormFields — Email and Password inputs
/// │   ├── email() — Email input with validation
/// │   ├── password() — Password input with visibility toggle
/// ├── StepperFormField — Numeric input with increment/decrement
/// └── DescriptionFormField — Multi-line text area
/// ```
///
/// ## Why This Structure?
///
/// 1. **Single Responsibility**: Each widget does ONE thing well
/// 2. **Easy Testing**: Each component can be unit tested independently
/// 3. **Maintainability**: Changes to password logic don't affect stepper
/// 4. **Scalability**: Easy to add new specialized fields
///
/// ## Usage
///
/// ```dart
/// import 'package:testingapp/utils/widgets/form_fields/form_fields.dart';
///
/// Password input
/// PasswordFormField(
///   controller: _passwordController,
///   hintText: 'Enter password',
/// )
///
/// Stepper input
/// StepperFormField(
///   controller: _quantityController,
///   title: 'Quantity',
///   step: 5,
/// )
///
/// Multi-line description
/// DescriptionFormField(
///   controller: _descController,
///   hintText: 'Enter description...',
///   maxLength: 500,
/// )

library;

export 'auth_form_fields.dart';
export 'common_form_field.dart';
export 'phone_form_field.dart';
