import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/profile/profile.dart';
import 'package:testingapp/utils/utils.dart';

class ProfileRepository extends ApiClient {
  ProfileRepository(): super(interceptors: [AuthInterceptor(rejectIfNoSession: true)]);

  /// Fetches the user profile from the server.
  /// Returns a [UserProfile] object if successful, otherwise throws an error.
  Future<UserProfile> getProfile() async {
    try {
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `get` method to make the API call.
      final response = Response<dynamic>(requestOptions: RequestOptions(path: '/profile'));
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

  Future<UserProfile> updateProfile(UpdateProfileRequest request) async {
    try {
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `put` method to make the API call.
      final response = Response<dynamic>(requestOptions: RequestOptions(path: '/profile'), data: request.toJson());
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

  /// Deletes the user profile from the server.
  /// Returns a [bool] indicating success or failure.
  Future<bool> deleteProfile() async {
    try {
      // TODO(ishanga): Remove the following section after implementing the API call. Use the `delete` method to make the API call.
      final response = Response<dynamic>(requestOptions: RequestOptions(path: '/profile'));
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
}
