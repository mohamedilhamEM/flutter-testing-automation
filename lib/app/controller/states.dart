import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/utils/utils.dart';

/// A class that represents the application states.
/// It provides getters and setters for various state variables.
class AppStates with ChangeNotifier {
  AppStates();

  final Box<bool> _storage = Hive.box<bool>('states'); // Need to open first before using, see bootstrap.dart

  /// The prefix for the home route.
  final String homePrefix = '/shell';

  Session? _currentSession;

  /// Returns true if the user is logged in, false otherwise.
  bool get isLogin => _currentSession != null;
  Session? get currentSession => _currentSession;

  set currentSession(Session? value) {
    _currentSession = value;
    notifyListeners();
  }

  /// Represents the state of internet connection.
  bool _hasInternetConnection = true;

  /// Returns true if the app has a connection, false otherwise.
  bool get hasInternetConnection => _hasInternetConnection;

  /// Sets the internet connection state.
  /// Notifies the listeners after setting the value.
  set hasInternetConnection(bool value) {
    if (_hasInternetConnection != value) {
      _hasInternetConnection = value;
      notifyListeners();
    }
  }

  /// Represents the state of initialization.
  /// This class provides a boolean value indicating whether the object is initialized or not.
  bool _isInitialized = false;

  /// Returns the current initialization state.
  bool get isInitialized => _isInitialized;

  /// Sets the initialization state.
  /// Notifies the listeners after setting the value.
  set isInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  /// Returns a boolean value indicating whether the code is verified.
  ///
  /// If the current session is not null, it checks if the email is verified.
  /// If the email is verified, it returns true; otherwise, it returns false.
  bool get isCodeVerified => _currentSession?.isEmailVerified ?? false;

  /// Returns whether the account is completed or not.
  bool get isAccountCompleted => _currentSession?.isProfileCompleted ?? false;

  /// Represents the state of the tutorial page.
  bool _isTutorialShown = false;

  /// Returns whether the tutorial page is shown or not.
  bool get isTutorialShown => _isTutorialShown;

  /// Sets the state of the tutorial page.
  set isTutorialShown(bool value) {
    _isTutorialShown = value;
    unawaited(_storage.put('isTutorialShown', value));
    notifyListeners();
  }

  /// This method is called when the app starts.
  /// It retrieves the value of 'isTutorialShown' from storage and assigns it to the '_isTutorialShown' variable.
  /// If the value is null, it assigns 'false' as the default value.
  /// Finally, it notifies the listeners about the changes.
  Future<void> onAppStart() async {
    _isTutorialShown = _storage.get('isTutorialShown') ?? false;

    // Track connectivity
    final settings = GetIt.instance<AppSettings>();
    if (settings.showOfflineOverlay) {
      final connectivity = GetIt.instance<ConnectivityService>();
      hasInternetConnection = await connectivity.hasConnectivity();
      connectivity.onConnectivityChanged.listen((isConnected) {
        hasInternetConnection = isConnected;
      });
    }

    notifyListeners();
  }
}
