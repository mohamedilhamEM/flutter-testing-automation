import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

/// This file contains the [AppSettings] class, which represents the application settings.
/// It provides methods and properties to access various settings based on the current environment.
/// The [AppSettings] class also includes methods to retrieve device information such as device ID and device name.
/// The [AppEnvironment] enum defines the possible environments: development, production, and staging.
/// The [AppSettingValue] class is a generic class that represents a setting value with different values for each environment.
///
/// Example usage:
///
/// ```dart
/// final settings = AppSettings(AppEnvironment.development);
///
/// print(settings.isDevelopment);
/// print(settings.baseUrl);
/// print(await settings.getDeviceId());
/// ```
class AppSettings {
  AppSettings(this._environment);

  final AppEnvironment _environment;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final Uuid uuid = const Uuid();

  bool get isDevelopment => _environment == AppEnvironment.development;
  bool get isProduction => _environment == AppEnvironment.production;
  bool get isStaging => _environment == AppEnvironment.staging;

  /// Whether to show the persistent offline overlay when internet is disconnected.
  bool get showOfflineOverlay => true;

  /// Opens the device settings, targeting network/internet toggles.
  Future<void> openSettings() async {
    try {
      if (Platform.isAndroid) {
        // Use intent to reach connectivity settings directly
        Uri.parse('package:com.android.settings');
        // wireless_settings is the standard action for network screens
        const action = 'android.settings.WIRELESS_SETTINGS';
        await launchUrl(Uri(
          scheme: 'intent',
          path: '#Intent;action=$action;end',
        ),);
      } else if (Platform.isIOS) {
        final url = Uri.parse('app-settings:');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      }
    } on Object catch (e) {
      log('Error opening settings: $e');
      // Final fallback to general settings
      if (Platform.isAndroid) {
        await launchUrl(Uri.parse('package:com.android.settings'));
      }
    }
  }

  /// Returns the base URL from environment variables
  String get baseUrl => dotenv.get('BASE_URL', fallback: '');

  /// Returns the API key from environment variables
  String get apiKey => dotenv.get('API_KEY', fallback: '');

  /// Returns the session secret key from environment variables
  String get sessionSecretKey => dotenv.get('SESSION_KEY', fallback: 'session');

  /// `Add more settings if needed below`
  /// `follow the above pattern for environment-specific values if necessary`
  

  final _countryCodes = const AppSettingValue<List<String>>(
    developmentValue: ['+61', '+94'],
    productionValue: ['+61'],
    stagingValue: ['+61'],
  );

  List<String> get countryCodes {
    switch (_environment) {
      case AppEnvironment.development:
        return _countryCodes.developmentValue;
      case AppEnvironment.production:
        return _countryCodes.productionValue ?? _countryCodes.developmentValue;
      case AppEnvironment.staging:
        return _countryCodes.stagingValue ?? _countryCodes.developmentValue;
    }
  }

  /// Returns the device platform as a string.
  /// If the platform is Android, it returns 'ANDROID'.
  /// If the platform is iOS, it returns 'IOS'.
  /// If the platform is unknown or an error occurs, it returns 'UNKNOWN'.
  String getDevicePlatform() {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        return 'ANDROID';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        return 'IOS';
      } else {
        return 'UNKNOWN';
      }
    } on Object catch (e) {
      log('Error getting device Platform: $e');
      return 'UNKNOWN';
    }
  }

  /// Retrieves the device ID asynchronously.
  ///
  /// This method checks the default target platform and retrieves the device ID accordingly.
  /// If the default target platform is Android, it uses the `deviceInfoPlugin` to get the Android device ID.
  /// If the default target platform is iOS, it uses the `DeviceInfoPlugin` to get the iOS device ID.
  /// If the default target platform is neither Android nor iOS, it returns a default device ID of 'UNKNOWN'.
  ///
  /// If an error occurs while retrieving the device ID, it logs the error and returns a default device ID of 'UNKNOWN'.
  ///
  /// Returns the device ID as a `String`.
  Future<String> getDeviceId() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        return uuid.v5(Namespace.dns.value, androidInfo.id);
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        return uuid.v5(Namespace.dns.value, iosInfo.identifierForVendor);
      } else {
        return uuid.v5(Namespace.dns.value, 'UNKNOWN');
      }
    } on Object catch (e) {
      log('Error getting device ID: $e');
      return uuid.v5(Namespace.dns.value, 'UNKNOWN');
    }
  }
}

/// Enum representing different environments for the application.
///
/// The [AppEnvironment] enum defines three different environments:
/// - development: Used for local development and testing.
/// - production: Used for the live production environment.
/// - staging: Used for staging or pre-production environment.
enum AppEnvironment {
  development,
  production,
  staging,
}

/// A generic class representing the value of an application setting.
///
/// The [AppSettingValue] class is used to define the default value of a setting,
/// as well as optional values for different environments such as development,
/// production, and staging. The type parameter [T] represents the type of the value.
class AppSettingValue<T> {
  const AppSettingValue({
    required this.developmentValue,
    this.productionValue,
    this.stagingValue,
  });

  final T developmentValue;
  final T? productionValue;
  final T? stagingValue;
}
