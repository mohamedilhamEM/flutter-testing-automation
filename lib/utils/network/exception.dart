import 'package:testingapp/utils/utils.dart';

/// Custom exception class for API errors.
class ApiError implements Exception {
  ApiError({
    required this.message,
    this.statusCode = 500,
  });

  /// Constructs an [ApiError] object from a JSON map.
  factory ApiError.fromJson(Map<String, dynamic> json, {int statusCode = 0}) => ApiError(
        message: json['message'] as String,
        statusCode: statusCode,
      );

  String message;
  int statusCode;

  /// Converts the [ApiError] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': message,
      };

  /// Creates a clone of the [ApiError] object.
  ApiError clone() => ApiError.fromJson(toJson());

  @override
  String toString() => 'Error: $errorMessage';

  /// Returns the error message as a string.
  String get errorMessage => message;
}

/// Handles the error and converts it into an [ApiError] object.
///
/// If the error is a [DioException], it checks if the response data is a map.
/// If it is, it throws an [ApiError] object by parsing the response data.
/// If it's not a map, it throws an [ApiError] object with a default message and status code.
///
/// If the error is not a [DioException], it throws an [ApiError] object with the error message and status code.
///
/// If any exception occurs during the error handling process, it throws an [ApiError] object with the exception message and status code.
T onError<T>(Exception e) {
  try {
    if (e is DioException) {
      final isNetworkError = e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.error == 'No internet connection';

      if (isNetworkError) {
        throw ApiError(
            message: 'Network error. Please check your internet connection.',
            statusCode: 0,);
      }
      if (e.response?.data is Map<String, dynamic>) {
        throw ApiError.fromJson(e.response?.data as Map<String, dynamic>, statusCode: e.response?.statusCode ?? 0);
      } else {
        throw ApiError(message: e.message ?? 'Unknown Error', statusCode: 400);
      }
    } else {
      throw ApiError(message: e.toString(), statusCode: 400);
    }
  } on ApiError {
    rethrow;
  } catch (e) {
    throw ApiError(message: e.toString(), statusCode: 400);
  }
}
