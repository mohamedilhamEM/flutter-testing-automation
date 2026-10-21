import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/utils/utils.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({this.rejectIfNoSession = false});

  final bool rejectIfNoSession;

  // Lazily get the box using the key from AppSettings
  Box<String> get _storage => Hive.box<String>(GetIt.instance<AppSettings>().sessionSecretKey);

  /// Public endpoints that don't require authentication
  static const Set<String> _publicEndpoints = {
    '/login',
    '/password/email',
    '/register',
  };

  /// Checks if the given path should skip token injection
  /// 
  /// Uses exact path matching to prevent security vulnerabilities.
  /// Example: "/malicious/login" will NOT match "/login"
  bool _isPublicEndpoint(String path) {
    try {
      final uri = Uri.parse(path);
      return _publicEndpoints.contains(uri.path);
    } on Exception catch (_) {
      return false;
    }
  }

  Future<Session?> getCurrentSession() async {
    final sessionJson = _storage.get('session');
    if (sessionJson == null) return null;

    return Session.fromJson(jsonDecode(sessionJson) as Map<String, dynamic>);
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }
    final session = await getCurrentSession();
    if (session == null) {
      if (rejectIfNoSession) {
        return handler.reject(DioException(requestOptions: options, error: 'No session found, please login.'));
      }
      return handler.next(options);
    }
    options.headers['x-access-token'] = session.accessToken;

    return handler.next(options);
  }
}
