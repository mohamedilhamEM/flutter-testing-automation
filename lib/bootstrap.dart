import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/more/more.dart';
import 'package:testingapp/profile/profile.dart';
import 'package:testingapp/utils/utils.dart';

/// Returns the instance of the GetIt service locator.
///
/// The GetIt service locator is a singleton class that provides a convenient way to access
/// and manage dependencies in your application. This getter method returns the instance
/// of the GetIt service locator.
GetIt get getIt => GetIt.instance;

/// Boots up the application by initializing necessary components and running the provided builder function.
///
/// The [builder] function is responsible for creating the root widget of the application.
/// The [environment] parameter specifies the environment in which the application is running.
/// This function sets up error handling, initializes Flutter bindings, and registers singletons for various services.
Future<void> bootstrap(FutureOr<Widget> Function() builder, {required AppEnvironment environment}) async {
  FlutterError.onError = (details) {
    debugPrintStack(stackTrace: details.stack, label: details.exceptionAsString(), maxFrames: 10);
  };
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // Load environment-specific configuration
  await loadEnvFile(environment);
  
  // Initialize Hive with encryption
  await hiveInit();
  
  await setup(environment: environment);
  runApp(await builder());
}

/// Sets up the application by registering necessary dependencies and initializing services.
///
/// The [environment] parameter specifies the application environment.
/// It registers the Classes as singletons using the GetIt service locator.
Future<void> setup({required AppEnvironment environment}) async {
  getIt
    ..registerSingleton<ConnectivityService>(ConnectivityService())
    ..registerSingleton<AppSettings>(AppSettings(environment))
    ..registerSingletonAsync<AppStates>(() async {
      await Hive.openBox<bool>('states');
      return AppStates();
    })
    ..registerSingletonAsync<AuthService>(() async {
      // Open session box with encryption for security
      await Hive.openBox<String>(
        getIt<AppSettings>().sessionSecretKey,
        encryptionCipher: _encryptionCipher,
      );
      return AuthService();
    })
    ..registerSingletonWithDependencies<UserProfileService>(UserProfileService.new, dependsOn: [AuthService])
    ..registerSingletonWithDependencies(AppRouter.new, dependsOn: [AppStates])
    ..registerSingletonAsync<ThemeServiceProvider>(() async {
      await Hive.openBox<bool>('themeMode');
      final isDark = Hive.box<bool>('themeMode').get('isDark') ?? false;
      ThemeServiceProvider.setSystemUIOverlayStyle(isDark: isDark);
      return ThemeServiceProvider(isDark: isDark);
    })
    ..registerSingletonWithDependencies<MoreController>(MoreController.new, dependsOn: [AuthService]);

  await getIt.allReady();
}

/// Initializes Hive database for Flutter with encryption.
/// This function must be called before using any Hive functionality.
/// Uses flutter_secure_storage to securely store the encryption key.
/// Returns a Future that completes when the initialization is done.
Future<void> hiveInit() async {
  await Hive.initFlutter();
  
  // Set up encryption for sensitive data
  const secureStorage = FlutterSecureStorage();
  var encryptionKey = await secureStorage.read(key: 'hive_encryption_key');
  
  if (encryptionKey == null) {
    // Generate a new encryption key
    final key = Hive.generateSecureKey();
    encryptionKey = base64UrlEncode(key);
    await secureStorage.write(key: 'hive_encryption_key', value: encryptionKey);
  }
  
  // Store the encryption key globally for use when opening boxes
  final encryptionKeyBytes = base64Url.decode(encryptionKey);
  _encryptionCipher = HiveAesCipher(encryptionKeyBytes);
}

/// Global encryption cipher for Hive boxes
HiveAesCipher? _encryptionCipher;

/// Loads the environment-specific .env file
Future<void> loadEnvFile(AppEnvironment environment) async {
  final envFile = switch (environment) {
    AppEnvironment.development => 'env/.env.development',
    AppEnvironment.production => 'env/.env.production',
    AppEnvironment.staging => 'env/.env.staging',
  };
  
  await dotenv.load(fileName: envFile);
}
