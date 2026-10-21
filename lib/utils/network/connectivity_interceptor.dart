import 'dart:developer';

import 'package:testingapp/utils/utils.dart';

/// Interceptor that checks for internet connectivity before making an API call.
///
/// If no connectivity is detected, it rejects the request with a [DioException]
/// before it even leaves the device.
class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final connectivityService = GetIt.instance<ConnectivityService>();

    if (!connectivityService.isConnected) {
      log('No internet connectivity. Rejecting request: ${options.path}',
          name: 'ConnectivityInterceptor',);
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'No internet connection',
          type: DioExceptionType.connectionError,
        ),
      );
    }

    return handler.next(options);
  }
}
