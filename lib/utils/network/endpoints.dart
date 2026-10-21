/// API Endpoints configuration for Starter App
///
/// This file contains all API endpoint paths used throughout the application.
/// All endpoints are relative to the base URL defined in the environment variables.
///
/// Usage:
/// ```dart
/// import 'package:testingapp/utils/utils.dart';
///
/// final response = await post(AuthEndpoints.login, data: request.toFormData());
/// ```
library;

/// Authentication related endpoints
class AuthEndpoints {
  const AuthEndpoints._();

  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String resendCode = '/resend-code';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/password/email';
  static const String profile = '/profile';
}
