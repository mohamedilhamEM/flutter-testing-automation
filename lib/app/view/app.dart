import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/l10n/gen/app_localizations.dart';
import 'package:testingapp/profile/profile.dart';
import 'package:testingapp/utils/utils.dart';

class TestingApp extends StatefulWidget {
  const TestingApp({super.key});

  @override
  State<TestingApp> createState() => _TestingAppState();
}

class _TestingAppState extends State<TestingApp> {
  final AppStates _appStates = GetIt.instance<AppStates>();
  final ThemeServiceProvider _themeServiceProvider = GetIt.instance<ThemeServiceProvider>();

  /// A stream subscription for handling BoxEvent changes related to authentication state.
  late StreamSubscription<BoxEvent> _authStateSubscription;

  /// A stream subscription for handling ProfileState changes.
  late StreamSubscription<ProfileState> _profileStateSubscription;

  @override
  void initState() {
    /// Subscribes to changes in the Hive box containing sessions and listens for authentication state changes.
    ///
    /// The [onAuthStateChanged] callback function will be called whenever there is a change in the authentication state.
    _authStateSubscription = Hive.box<String>(GetIt.instance<AppSettings>().sessionSecretKey).watch().listen(onAuthStateChanged);

    _profileStateSubscription = GetIt.instance<UserProfileService>().profileStateStream.listen((event) async {
      if (event is ProfileDeleted) {
        await GetIt.instance<AuthService>().onUserProfileDeleted();
      }
    });

    /// Listens to changes in the theme mode provided by the [_themeServiceProvider].
    /// If the theme mode is set to [ThemeMode.dark], it sets the system UI overlay style to dark.
    /// Otherwise, it sets the system UI overlay style to the default.
    _themeServiceProvider.addListener(() {
      if (_themeServiceProvider.themeMode == ThemeMode.dark) {
        ThemeServiceProvider.setSystemUIOverlayStyle(isDark: true);
      } else {
        ThemeServiceProvider.setSystemUIOverlayStyle();
      }
    });
    super.initState();
  }

  /// Callback function that is triggered when the authentication state changes.
  ///
  /// It updates the current session in the app state based on the provided [event].
  /// If the [event] value is not null, it sets the current session to the value of the event.
  /// If the [event] value is null, it resets the app state to the initial state by setting the current session to null and isInitialized to false.
  ///
  /// **Note**: In the future, we'll also use this function to clear saved user cache related data from other services.
  void onAuthStateChanged(BoxEvent event) {
    log('onAuthStateChanged: ${event.value}', name: 'StarterAppState');
    if (event.value != null && event.value is String) {
      _appStates.currentSession = Session.fromJson(jsonDecode(event.value as String) as Map<String, dynamic>);
    } else {
      _appStates
        ..currentSession = null
        ..isInitialized = false; // Reset the app state to initial state when the user logs out
    }
  }

  @override
  void dispose() {
    unawaited(_authStateSubscription.cancel());
    unawaited(_profileStateSubscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => GetIt.instance<AppSettings>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<ThemeServiceProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<AppStates>()),

      ],
      child: Builder(
        builder: (context) {
          return ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
            child: MaterialApp.router(                        
              onGenerateTitle: (context) => context.l10n.appName,
              theme: context.watch<ThemeServiceProvider>().lightTheme,
              darkTheme: context.watch<ThemeServiceProvider>().darkTheme,
              themeMode: context.watch<ThemeServiceProvider>().themeMode,
              // locale: context.watch<LocaleProvider>().locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: GetIt.instance<AppRouter>().goRouter,
              builder: (context, child) => OverlayUtility(child: child),
            ),
          );
        },
      ),
    );
  }
}
