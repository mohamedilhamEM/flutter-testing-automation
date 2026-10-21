import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/profile/profile.dart';
import 'package:testingapp/utils/utils.dart';

/// This class represents a repository for authentication-related operations.
/// It extends the [ApiClient] class.
class AuthRepository extends ApiClient {
  AuthRepository() : super(interceptors: [AuthInterceptor(rejectIfNoSession: true)], name: 'AuthRepository');

  /// Registers a new user with the provided [request] data.
  /// Returns a [Future] that completes with a [UserProfileWithToken] object if the registration is successful.
  /// Throws an [Exception] if the registration fails.
  Future<UserProfileWithToken> register(RegisterRequestModel request) async {
    try {      
      final tempPayload = {
        'result': true,
        'message': 'User registered successfully',
        'payload': {
          'id': '1',
          'access_token': 'token',
          'created_at': DateTime.now().toIso8601String(),
          'is_email_verified': false,
          'is_profile_completed': false,
        },
      };
      final response = Response<dynamic>(requestOptions: RequestOptions(path: AuthEndpoints.register), data: tempPayload);
      // real API call goes here
      // final response = await post(AuthEndpoints.register, data: request.toFormData());
      // final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return UserProfileWithToken.fromJson(apiResponse.data as Map<String, dynamic>);
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }

  /// Logs in a user with the provided [request] data.
  /// Returns a [Future] that completes with a [UserProfileWithToken] object if the login is successful.
  /// Throws an [Exception] if the login fails.
  Future<UserProfileWithToken> logIn(LogInRequestModel request) async {
    try {
      final tempPayload = {
        'result': true,
        'message': 'User logged in successfully',
        'payload': {
          'id': '1',
          'access_token': 'token',
          'created_at': DateTime.now().toIso8601String(),
          'is_email_verified': false,
          'is_profile_completed': false,
        },
      };
      await Future.delayed(const Duration(seconds: 2), () {});
      final response = Response<dynamic>(requestOptions: RequestOptions(path: AuthEndpoints.login), data: tempPayload);      
      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);

      // real API call goes here    
      // final response = await post(AuthEndpoints.login, data: request.toFormData());
      // final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      
      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return UserProfileWithToken.fromJson(apiResponse.data as Map<String, dynamic>);
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }

  /// Logs out the current user.
  /// Returns a [Future] that completes with a [bool] value indicating whether the logout is successful.
  /// Throws an [Exception] if the logout fails.
  Future<bool> logOut({required String token}) async {
    try {
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `post` method to make the API call.
      // return Session if successful, throw Exception if failed
      final tempPayload = {
        'result': true,
        'message': 'User logged out successfully',
      };
      final response = Response<dynamic>(requestOptions: RequestOptions(path: AuthEndpoints.logout), data: tempPayload);
      // real API call goes here

      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return true;
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }

  /// Resend the verification code for email verification during registration.
  /// Returns a [Future] that completes with a [bool] value indicating whether the resend is successful.
  /// Throws an [Exception] if the resend fails.
  Future<bool> resendVerifyCode({required String token}) async {
    try {
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `post` method to make the API call.
      // return Session if successful, throw Exception if failed
      final tempPayload = {
        'result': true,
        'message': 'Verification code resent successfully',
      };
      final response = Response<dynamic>(requestOptions: RequestOptions(path: AuthEndpoints.resendCode), data: tempPayload);
      // real API call goes here

      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return true;
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }

  /// Verifies the user's email with the provided [code].
  /// Returns a [Future] that completes with a [UserProfile] object if the verification is successful.
  /// Throws an [Exception] if the verification fails.
  Future<UserProfile> verifyEmail({required String code, required String token}) async {
    try {
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `post` method to make the API call.
      // return UserProfile if successful, throw Exception if failed
      final tempPayload = {
        'result': true,
        'message': 'Email verified successfully',
        'payload': {
          'id': '1',
          'access_token': 'token',
          'created_at': DateTime.now().toIso8601String(),
          'is_email_verified': true,
          'is_profile_completed': false,
        },
      };
      final response = Response<dynamic>(requestOptions: RequestOptions(path: AuthEndpoints.verifyEmail), data: tempPayload);
      // real API call goes here

      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return UserProfile.fromJson(apiResponse.data as Map<String, dynamic>);
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }
  
  /// Fetches the current user's profile information from the server.
  ///
  /// This method makes a GET request to the '/profile' endpoint with the provided
  /// authentication token.
  ///
  /// Parameters:
  ///   - token: The authentication token to be included in the request header.
  ///
  /// Returns:
  ///   A [Future] that resolves to a [UserProfile] object containing the user's
  ///   profile information.
  Future<UserProfile> getCurrentUser({required String token}) async {
    try {      
      // final response = await get(AuthEndpoints.profile);
      // final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);      
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `get` method to make the API call.
      // return UserProfile if successful, throw Exception if failed
      final data = {
        'result': true,
        'message': 'User profile fetched successfully',
        'payload': {
          'uuid': '12345',
          'firstName': 'John',
          'lastName': 'Doe',
        },
      };
      final response = Response<dynamic>(requestOptions: RequestOptions(path: AuthEndpoints.profile), data: data);
      // real API call goes here
      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return UserProfile.fromJson(apiResponse.data as Map<String, dynamic>);
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }
}
