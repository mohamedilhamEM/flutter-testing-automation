import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/profile/profile.dart';
import 'package:testingapp/utils/utils.dart';

class AuthService extends AuthRepository {
  AuthService() : super();

  final StreamController<AuthState> _authStateSubject = StreamController<AuthState>.broadcast();
  final Box<String> _storage = Hive.box<String>(GetIt.instance<AppSettings>().sessionSecretKey); // Need to open first before using, see bootstrap.dart

  Stream<AuthState> get onAuthStateChanges => _authStateSubject.stream;

  /// Logs in the user with the provided [email] and [password].
  /// 
  /// This method sets the authentication state to [AuthLoading] and then attempts to log in the user using the provided credentials.
  /// It retrieves the device platform and device ID from the [AppSettings] instance using [GetIt] and creates a [LogInRequestModel] with the email, password, device ID, and device platform.
  /// The method then calls the [logIn] function to send the login request and awaits the response.
  /// If the login is successful, the session is saved using [_saveSession] and the authentication state is set to [AuthSuccess] with the session response.
  /// If an error occurs during the login process, the authentication state is set to [AuthFailed] with the error message.
  /// 
  /// Throws an exception if any error occurs during the login process.
  Future<void> login(String email, String password) async {
    _authStateSubject.add(AuthLoading());
    try {
      final devicePlatform = GetIt.instance<AppSettings>().getDevicePlatform();
      final deviceId = await GetIt.instance<AppSettings>().getDeviceId();
      final request = LogInRequestModel(
        email: email,
        password: password,
        deviceId: deviceId,
        deviceType: devicePlatform,
      );

      final profile = await logIn(request);
      final newSession = Session.fromJson(profile.toJson());

      /// Update the user profile in the UserProfileService
      GetIt.instance<UserProfileService>().userProfile = profile.userProfile;

      /// Save the session to the local storage
      await _saveSession(newSession);

      /// Emit the success state with the new session
      _authStateSubject.add(AuthSuccess(session: newSession));
    } on Object catch (e) {
      _authStateSubject.add(AuthFailed(e.toString()));
    }
  }

  /// Signs up a user with the provided [email], [password], and [phone].
  /// This method updates the authentication state by adding [AuthLoading] to the [_authStateSubject].
  /// It then creates a [RegisterRequestModel] with the provided parameters and sends a registration request.
  /// If the registration is successful, the session is saved and [AuthSuccess] with the session is added to the [_authStateSubject].
  /// If an error occurs during the registration process, [AuthFailed] with the error message is added to the [_authStateSubject].
  /// Throws an exception if any error occurs during the process.
  Future<void> signUp(String email, String password, String phone) async {
    _authStateSubject.add(AuthLoading());
    try {
      final devicePlatform = GetIt.instance<AppSettings>().getDevicePlatform();
      final deviceId = await GetIt.instance<AppSettings>().getDeviceId();
      final request = RegisterRequestModel(
        email: email,
        password: password,
        deviceId: deviceId,
        deviceType: devicePlatform,
      );

      final profile = await register(request);
      final newSession = Session.fromJson(profile.toJson());

      /// Update the user profile in the UserProfileService
      GetIt.instance<UserProfileService>().userProfile = profile.userProfile;

      /// Save the session to the local storage
      await _saveSession(newSession);

      /// Emit the success state with the new session
      _authStateSubject.add(AuthSuccess(session: newSession));
    } on Object catch (e) {
      log('Sign up failed: $e', name: 'AuthService');
      _authStateSubject.add(AuthFailed(e.toString()));
    }
  }

  /// Verifies the given [code] for email verification.
  /// 
  /// This method updates the authentication state to [AuthLoading] and then proceeds to verify the email using the provided [code].
  /// If the verification is successful, the session is saved and the authentication state is updated to [AuthCodeVerified].
  /// If the verification fails, the authentication state is updated to [AuthCodeVerificationFailed] with the error message.
  /// 
  /// Throws an [Exception] if no session is found.
  Future<void> verify(String code) async {
    _authStateSubject.add(AuthLoading());
    try {
      var session = await _getSession();
      if (session == null) {
        throw Exception('No session found');
      }

      final response = await verifyEmail(code: code, token: session.accessToken);

      /// Update the user profile in the UserProfileService
      GetIt.instance<UserProfileService>().userProfile = response;

      /// Preserve the access token from the previous session and update the session with the new data
      session = session.syncPreserveAccessToken(Session.fromJson(response.toJson()));
      await _saveSession(session);
      _authStateSubject.add(AuthCodeVerified(session: session));
    } on Object catch (e) {
      log('Verification failed: $e', name: 'AuthService');
      _authStateSubject.add(AuthCodeVerificationFailed(e.toString()));
    }
  }

  /// Resend the verification code for the user.
  ///
  /// This method sends a new verification code to the user's email address
  /// or phone number. It updates the authentication state to [AuthLoading]
  /// while the code is being resent. If the session is not found, it throws
  /// an exception with the message 'No session found'. After successfully
  /// resending the code, it updates the authentication state to [AuthCodeResent].
  /// If an exception occurs during the process, it updates the authentication
  /// state to [AuthCodeResendFailed] with the error message.
  ///
  /// Throws an [Exception] if there is an error while resending the code.
  Future<void> resendVerificationCode() async {
    _authStateSubject.add(AuthLoading());
    try {
      final session = await _getSession();
      if (session == null) {
        throw Exception('No session found');
      }

      await resendVerifyCode(token: session.accessToken);
      _authStateSubject.add(AuthCodeResent());
    } on Object catch (e) {
      log('Resend verification code failed: $e', name: 'AuthService');
      _authStateSubject.add(AuthCodeResendFailed(e.toString()));
    }
  }

  /// Sends a forgot password request for the given [email].
  /// 
  /// This method simulates a forgot password request by delaying for 2 seconds.
  /// If the [email] matches the demo email, it emits an [AuthForgotPasswordSubmitSuccess] event.
  /// Otherwise, it throws an [Exception] with the message 'Invalid email' and emits an [AuthForgotPasswordSubmitFailed] event.
  /// 
  /// Throws an [Exception] if an error occurs during the process.
  Future<void> forgotPassword(String email) async {
    _authStateSubject.add(AuthLoading());
    try {
      /// This is just a demo forgot password request
      /// Replace with actual forgot password request
      const demoEmail = 'demo@demo.com';
      await Future.delayed(const Duration(seconds: 2), () {});
      if (email == demoEmail) {
        _authStateSubject.add(AuthForgotPasswordSubmitSuccess());
        return;
      } else {
        throw Exception('Invalid email');
      }
    } on Object catch (e) {
      log('Forgot password failed: $e', name: 'AuthService');
      _authStateSubject.add(AuthForgotPasswordSubmitFailed(e.toString()));
    }
  }

  /// Logs out the user.
  ///
  /// This method sets the [_authStateSubject] to [AuthLoading] state
  /// If the logout is successful, it sets the [_authStateSubject] to [AuthInitial] state.
  /// If an error occurs during the logout process, it sets the [_authStateSubject] to [AuthFailed] state with the error message.
  ///
  /// Throws an exception if an error occurs during the logout process.
  Future<void> logout() async {
    _authStateSubject.add(AuthLoading());
    try {
      final session = await _getSession();
      if (session == null) {
        throw Exception('No session found');
      }
      
      await logOut(token: session.accessToken);
      await _deleteSession();
      _authStateSubject.add(AuthLogout());
    } on Object catch (e) {
      log('Logout failed: $e', name: 'AuthService');
      _authStateSubject.add(AuthFailed(e.toString()));
    }
  }

  /// Saves the session to storage.
  ///
  /// [session] - The session object to be saved.
  ///
  /// Returns a [Future] that completes when the session is saved.
  Future<void> _saveSession(Session session) async {
    await _storage.put('session', jsonEncode(session.toJson()));
  }

  /// Retrieves the session from storage.
  ///
  /// Returns a [Future] that completes with the session object, or `null` if no session is found.
  Future<Session?> _getSession() async {
    final session = _storage.get('session');
    if (session == null) {
      return null;
    }
    return Session.fromJson(jsonDecode(session) as Map<String, dynamic>);
  }

  /// Deletes the session from storage.
  ///
  /// Returns a [Future] that completes when the session is deleted.
  Future<void> _deleteSession() async {
    await _storage.delete('session');
  }

  
  /// Refreshes the current user session by obtaining a new authentication token.
  /// 
  /// This method is typically called when the current session has expired or
  /// is about to expire. It handles the token refresh process automatically
  /// and updates the user's authentication state.
  /// 
  /// Throws [Exception] if the refresh fails due to invalid credentials
  /// or network issues.
  /// 
  /// Example:
  /// ```dart
  /// try {
  ///   await authService.refreshSession();
  ///   print('Session refreshed successfully');
  /// } catch (e) {
  ///   print('Failed to refresh session: $e');
  /// }
  /// ```
  Future<void> refreshSession() async {
    var session = await _getSession();
    if (session != null) {
      // Check connectivity before attempting any network calls
      final hasConnectivity = await GetIt.instance<ConnectivityService>().hasConnectivity();
      if (!hasConnectivity) {
        log('No internet connectivity detected', name: 'AuthService');
        _authStateSubject.add(AuthNoConnectivity(message: 'No internet connection'));
        return;
      }

      _authStateSubject.add(AuthLoading());
      final cancellationToken = CancellationToken();
      const options = RetryOptions(
        strategy: ExponentialBackoffStrategy(
          baseDelay: Duration(seconds: 1),
        ),
        operationName: 'Verify Session Retry',
      );

      try {

        final result = await options.retryWithResult<UserProfile>(
          (attempt) => getCurrentUser(token: session!.accessToken),
          retryIf: (error) {
            // Do NOT retry on token/auth errors (401, 403)
            if (error is DioException && error.response != null) {
              final statusCode = error.response!.statusCode;
              if (statusCode == 401 || statusCode == 403) {
                return false;
              }
            }
            // Also do NOT retry on parsed ApiError with auth status codes
            if (error is ApiError && (error.statusCode == 401 || error.statusCode == 403)) {
              return false;
            }
            // Retry only on connection-related errors
            return error is DioException && [
              DioExceptionType.connectionError,
              DioExceptionType.connectionTimeout,
              DioExceptionType.receiveTimeout,
            ].contains(error.type);
          },
          onRetry: (p0, p1) {
            log('Retrying session verification: Attempt $p1', name: 'AuthService');
            final lastError = p0 is DioException ? p0.message : p0.toString();
            _authStateSubject.add(
              AuthRetrying(
                message: 'Error connecting to server, retrying...',
                retryCount: p1,
                lastError: lastError,
                cancellationToken: cancellationToken,
              ),
            );
          },
          cancellationToken: cancellationToken,
        );

        // If the retry was successful, we get the user profile from the result
        final response = result.value;

        /// Update the user profile in the UserProfileService
        GetIt.instance<UserProfileService>().userProfile = response;
        /// Sync the session with the new user profile
        /// and preserve the access token
        /// This is to ensure that the access token is not lost
        /// when the user profile is updated
        /// and the session is saved again
        session = session.syncPreserveAccessToken(Session.fromJson(response.toJson()));
        _authStateSubject.add(AuthSuccess(session: session));
        /// We need to save the session again to trigger the session change listener in the [App] in app.dart
        await _saveSession(session);
      } on CancelledException {
        log('Session verification cancelled', name: 'AuthService');
        await _deleteSession();
        _authStateSubject.add(AuthInitial());
      } on Exception catch (e) {
        log('Error verifying session', name: 'AuthService', error: e);

        // Determine if this is a token/auth error
        final isTokenError = _isTokenError(e);

        if (isTokenError) {
          // Token is invalid/expired — clear session so user can log in again
          await _deleteSession();
          _authStateSubject.add(AuthSessionExpired(message: 'Session expired'));
        } else {
          // Server/network error after all retries exhausted
          _authStateSubject.add(AuthRetryingFailed(message: 'Error connecting to server!'));
        }
        // Do NOT rethrow — let splash screen handle the state gracefully
      }
    } else {
      _authStateSubject.add(AuthInitial());
    }
  }

  /// Checks if an exception indicates a token/authentication error.
  bool _isTokenError(Object error) {
    if (error is DioException && error.response != null) {
      final statusCode = error.response!.statusCode;
      return statusCode == 401 || statusCode == 403;
    }
    if (error is ApiError) {
      return error.statusCode == 401 || error.statusCode == 403;
    }
    return false;
  }

  /// Refreshes the current session without implementing retry logic.
  /// 
  /// This method retrieves the current session and attempts to refresh it by:
  /// 1. Fetching the current user data using the existing access token
  /// 2. Updating the user profile in the UserProfileService
  /// 3. Syncing the session while preserving the access token
  /// 4. Emitting appropriate auth states during the process
  /// 5. Saving the updated session to trigger session change listeners
  /// 
  /// The method emits different [AuthState] values:
  /// - [AuthLoading] when the refresh process starts
  /// - [AuthSuccess] when the session is successfully refreshed
  /// - [AuthRetryingFailed] if an error occurs during the refresh
  /// - [AuthInitial] if no session exists
  /// 
  /// This method does not implement automatic retry mechanisms - failures
  /// result in an immediate error state emission.
  /// 
  /// Throws: Does not throw exceptions directly, but catches and handles
  /// errors by emitting [AuthRetryingFailed] state.
  Future<void> refreshSessionWithOutRetry() async {
    var session = await _getSession();
    if (session != null) {
      _authStateSubject.add(AuthLoading());
      try {
        final response = await getCurrentUser(token: session.accessToken);

        /// Update the user profile in the UserProfileService
        GetIt.instance<UserProfileService>().userProfile = response;
        /// Sync the session with the new user profile
        /// and preserve the access token
        /// This is to ensure that the access token is not lost
        /// when the user profile is updated
        /// and the session is saved again
        session = session.syncPreserveAccessToken(Session.fromJson(response.toJson()));
        _authStateSubject.add(AuthSuccess(session: session));
        /// We need to save the session again to trigger the session change listener in the [App] in app.dart
        await _saveSession(session);
      } on Object catch (e) {
        log('Error verifying session', name: 'AuthService', error: e);
        _authStateSubject.add(AuthRetryingFailed(message:  'Error connecting to server!'));
      }
    } else {
      _authStateSubject.add(AuthInitial());
    }
  }

  /// Performs necessary actions when a user profile is deleted.
  /// 
  /// This method:
  /// 1. Deletes the current session by calling [_deleteSession]
  /// 2. Resets the authentication state to [AuthInitial]
  /// 
  /// Returns a [Future] that completes when all operations are done.
  Future<void> onUserProfileDeleted() async {
    log('User profile deleted', name: 'AuthService');
    /// Delete the current session
    /// and reset the authentication state
    /// to [AuthInitial]
    /// This is to ensure that the user is logged out
    await _deleteSession();
    _authStateSubject.add(AuthInitial());
  }
}
