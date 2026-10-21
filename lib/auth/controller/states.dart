import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/utils/utils.dart';

/// Represents the abstract base class for authentication states.
abstract class AuthState {
  const AuthState();
}

/// Represents the initial authentication state.
class AuthInitial extends AuthState {}

/// Represents the authentication state when loading.
class AuthLoading extends AuthState {}

/// Represents the authentication state when authentication is successful.
class AuthSuccess extends AuthState {
  const AuthSuccess({required this.session});
  final Session session;
}

/// Represents the state when an authentication code has been resent.
class AuthCodeResent extends AuthState {}

/// Represents the state when the resending of the authentication code fails.
class AuthCodeResendFailed extends AuthState {
  /// The error message associated with the code resending failure.
  const AuthCodeResendFailed(this.message);

  /// The error message associated with the code resending failure.
  final String message;
}

/// Represents the state when an authentication code has been verified.
class AuthCodeVerified extends AuthState {
  const AuthCodeVerified({required this.session});
  final Session session;
}

/// Represents the state when the code verification fails during the authentication process.
class AuthCodeVerificationFailed extends AuthState {
  /// The error message associated with the code verification failure.
  const AuthCodeVerificationFailed(this.message);
  
  /// The error message associated with the code verification failure.
  final String message;
}

/// Represents the state when the submission of the forgot password form fails.
class AuthForgotPasswordSubmitFailed extends AuthState {
  /// Creates an instance of [AuthForgotPasswordSubmitFailed] with the given [message].
  const AuthForgotPasswordSubmitFailed(this.message);

  /// The error message associated with the failed submission.
  final String message;
}

/// Represents the state when the submission of the forgot password form is successful.
class AuthForgotPasswordSubmitSuccess extends AuthState {}

/// Represents the authentication state when authentication fails.
class AuthFailed extends AuthState {
  const AuthFailed(this.message);
  final String message;
}

/// Represents the authentication state when logging out.
class AuthLogout extends AuthState {}

/// Represents the authentication state when the user is loading.
class AuthRetrying extends AuthLoading {
  AuthRetrying({required this.message, this.cancellationToken, this.retryCount, this.lastError, this.maxRetries = 8});
  final String message;
  final int? retryCount;
  final int maxRetries;
  final String? lastError;
  final CancellationToken? cancellationToken;
}

class AuthRetryingFailed extends AuthLoading {
  AuthRetryingFailed({required this.message});
  final String message;
}

/// Represents the authentication state when the session/token has expired or is invalid.
/// The user needs to log in again.
class AuthSessionExpired extends AuthState {
  AuthSessionExpired({required this.message});
  final String message;
}

/// Represents the authentication state when there is no internet connectivity.
/// The user should check their connection and retry.
class AuthNoConnectivity extends AuthState {
  AuthNoConnectivity({required this.message});
  final String message;
}
