import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/utils/utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _retryCount = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
    super.initState();
  }

  /// Initializes the application by removing the native splash,
  /// attempting session refresh, and handling errors gracefully.
  Future<void> init() async {
    FlutterNativeSplash.remove();
    // TODO(ishanga): Remove the delay after actual API calls are implemented.
    // This is just to simulate a loading state.
    await Future.delayed(const Duration(seconds: 2), () {});
    await GetIt.instance<AppStates>().onAppStart();
    await _attemptSessionRefresh();
  }

  /// Attempts to refresh the session and handles errors by
  /// showing appropriate snack-bars instead of getting stuck.
  Future<void> _attemptSessionRefresh() async {
    final authService = GetIt.instance<AuthService>();
    final completer = Completer<void>();

    late StreamSubscription<AuthState> subscription;

    /// Helper to clean up the subscription and complete the Future.
    void finalize() {
      unawaited(subscription.cancel());
      if (!completer.isCompleted) completer.complete();
    }

    subscription = authService.onAuthStateChanges.listen((state) {
      if (!mounted) {
        finalize();
        return;
      }

      switch (state) {
        case AuthNoConnectivity():
          _showErrorWithRetry(context.l10n.noInternetConnection);
          finalize();

        case AuthSessionExpired():
          context.showErrorSnackBar(context.l10n.sessionExpired);
          GetIt.instance<AppStates>().isInitialized = true;
          finalize();

        case AuthRetryingFailed():
          _showErrorWithRetry(context.l10n.serverConnectionError);
          finalize();

        case AuthSuccess() || AuthInitial():
          GetIt.instance<AppStates>().isInitialized = true;
          finalize();

        case AuthLoading() || AuthRetrying():
          // Intermediate/Loading states — Handled by StreamBuilder in build()
          break;

        default:
          // Fallback for any other unexpected terminal failure states
          if (state is AuthFailed || state is AuthCodeVerificationFailed) {
            finalize();
          }
      }
    });

    // Now trigger the refresh — the listener above is already active
    try {
      await authService.refreshSession();

      // Wait for the listener to process the terminal state
      await completer.future.timeout(const Duration(seconds: 15));
    } on Object catch (e) {
      log('Error during session refresh: $e');
      finalize();
      if (mounted) {
        _showErrorWithRetry('Error\n $e');
      }
    }
  }

  /// Shows an error snackbar with a "Retry" action button.
  void _showErrorWithRetry(String message) {
    if (!mounted) return;
    context.showErrorSnackBar(
      message,
      action: SnackBarAction(
        label: context.l10n.retry.toUpperCase(),
        textColor: context.colorScheme.onPrimary,
        onPressed: _retry,
      ),
    );
  }

  void _retry() {
    _retryCount++;
    if (_retryCount == 1) {
      unawaited(_attemptSessionRefresh());
    } else if (_retryCount >= 2) {
      final appStates = GetIt.instance<AppStates>();

      /// FAILSAFE: If the user is stuck because of connectivity issues or
      /// persistent session errors, the second tap forces a logout.
      unawaited(GetIt.instance<AuthService>().logout());

      // We briefly delay so Hive storage can be cleared before the router
      // reacts to the AppStates change.
      unawaited(
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            context.showErrorSnackBar('Session error. Please sign in again.');

            /// Forces the Splash loop to end.
            /// GoRouter monitors this value and will redirect based on the
            /// now-cleared auth state (redirecting to SignIn or Intro).
            appStates.isInitialized = true;
          }
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: AppLogo(aspectRatio: 1.5),
            ),
            Gaps.gapMd16,
            StreamBuilder(
              stream: GetIt.instance<AuthService>().onAuthStateChanges,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state is AuthLoading) {
                  if (state is AuthRetrying) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        ),
                        Gaps.gapMd16,
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: context.bodyLarge(
                            color: context.colorScheme.error,
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            if (state.lastError == null || state.lastError!.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text(
                                state.lastError ?? '',
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: context.bodySmall(
                                  color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            );
                          },
                        ),
                        Builder(
                          builder: (context) {
                            if (state.retryCount != null && state.retryCount! > 0) {
                              return Text(
                                'Attempt ${state.retryCount!} of ${state.maxRetries}',
                                style: context.bodySmall(
                                  color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        Gaps.gapXxl48,
                        Builder(
                          builder: (context) {
                            if (state.cancellationToken == null) {
                              return const SizedBox.shrink();
                            }
                            if (state.retryCount != null && state.retryCount! >= 3) {
                              return CommonButton.outline(
                                onPressed: () {
                                  state.cancellationToken?.cancel();
                                },
                                foregroundColor: context.colorScheme.error,
                                label: context.l10n.cancelLogout,
                                prefixIcon: Icons.cancel,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
