import 'dart:developer';

import 'package:testingapp/utils/utils.dart';

/// A class that represents a Dio client for making HTTP requests.
class ApiClient {
  ApiClient({List<Interceptor> interceptors = const [], String name = 'ApiClient'}) {
    _dio = Dio();
    _dio.options.baseUrl = GetIt.instance<AppSettings>().baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'accept': 'application/json',
      'x-api-key': GetIt.instance<AppSettings>().apiKey,
    };
    _dio.options.listFormat = ListFormat.multiCompatible;
    _dio.interceptors.add(ConnectivityInterceptor());
    _dio.interceptors.addAll(interceptors);
    _dio.interceptors.add(AwesomeDioInterceptor(logger: (value) => log(value, name: name)));
  }

  late Dio _dio;

  /// Sends a GET request to the specified [path] with optional [queryParameters] and [options].
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

  /// Sends a POST request to the specified [path] with optional [data], [queryParameters], and [options].
  Future<Response<dynamic>> post(
    String path, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    void Function(int count, int total)? onSendProgress,
  }) async =>
      _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
      );

  /// Sends a PUT request to the specified [path] with optional [data], [queryParameters], and [options].
  Future<Response<dynamic>> put(
    String path, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  /// Sends a DELETE request to the specified [path] with optional [data], [queryParameters], and [options].
  Future<Response<dynamic>> delete(
    String path, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
}
