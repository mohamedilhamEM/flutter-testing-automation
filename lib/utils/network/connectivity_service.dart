import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for checking and monitoring network connectivity status.
///
/// Wraps the `connectivity_plus` package to provide a clean API
/// for the rest of the app.
///
/// ## Usage
/// ```dart
/// final connectivityService = GetIt.instance<ConnectivityService>();
///
/// One-time check
/// if (await connectivityService.hasConnectivity()) {
///   Online
/// }
///
/// Listen to changes
/// connectivityService.onConnectivityChanged.listen((isConnected) {
///   if (!isConnected) showNoConnectionBanner();
/// });
/// ```
class ConnectivityService {
  /// Initializes the connectivity service and starts listening for status changes.
  ConnectivityService() {
    // Check initial connectivity immediately to populate the cache
    // so it can be used synchronously by the interceptor.
    unawaited(
      _connectivity.checkConnectivity().then((results) {
        _isConnectedCached = _isConnected(results);
        _controller.add(_isConnectedCached);
      }),
    );

    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        _isConnectedCached = _isConnected(results);
        log('Connectivity changed: $_isConnectedCached (results: $results)',
            name: 'ConnectivityService',);
        _controller.add(_isConnectedCached);
      },
    );
  }

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Holds the last known connectivity state.
  /// 
  /// This is used for synchronous "fail-fast" checks in network interceptors.
  bool _isConnectedCached = true;

  /// Returns the current cached connectivity status synchronously.
  /// 
  /// This is highly efficient for high-frequency checks (like per-API call)
  /// as it avoids asynchronous overhead.
  bool get isConnected => _isConnectedCached;

  /// Stream that emits `true` when connected, `false` when disconnected.
  Stream<bool> get onConnectivityChanged => _controller.stream;

  /// Checks current connectivity status.
  ///
  /// Returns `true` if the device has any network connection
  /// (WiFi, mobile data, ethernet, etc.), `false` if completely offline.
  Future<bool> hasConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _isConnected(results);
    } on Object catch (e) {
      log('Error checking connectivity: $e', name: 'ConnectivityService');
      // If we can't determine connectivity, assume connected
      // and let the actual API call fail with a proper error
      return true;
    }
  }

  /// Determines if any of the connectivity results indicate a connection.
  bool _isConnected(List<ConnectivityResult> results) {
    return results.any(
      (r) => r != ConnectivityResult.none,
    );
  }

  /// Disposes resources.
  void dispose() {
    unawaited(_subscription?.cancel());
    unawaited(_controller.close());
  }
}
