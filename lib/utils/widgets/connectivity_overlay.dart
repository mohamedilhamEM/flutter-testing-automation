import 'package:flutter/material.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/utils/utils.dart';

/// A widget that shows a non-blocking, slide-up connectivity banner
/// when the device is offline.
class ConnectivityOverlay extends StatefulWidget {
  const ConnectivityOverlay({required this.child, super.key});

  final Widget child;

  @override
  State<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends State<ConnectivityOverlay> with TickerProviderStateMixin {
  late Animation<Offset> _slideAnimation;
  late AnimationController _slideController;
  final AppSettings _settings = GetIt.instance<AppSettings>();

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Slide from below the viewport into its resting position.
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_settings.showOfflineOverlay) {
      return widget.child;
    }

    return Selector<AppStates, (bool, bool)>(
      selector: (context, appStates) => (
        appStates.hasInternetConnection,
        appStates.isInitialized,
      ),
      builder: (context, data, _) {
        final isConnected = data.$1;
        final isInitialized = data.$2;

        if (isConnected || !isInitialized) {
          _slideController.reverse();
        } else {
          _slideController.forward();
        }

        return Stack(
          children: [
            widget.child,

            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: MediaQuery.paddingOf(context).bottom + 80.h,
              child: ListenableBuilder(
                listenable: _slideController,
                builder: (context, _) {
                  if (_slideController.value == 0) {
                    return const SizedBox.shrink();
                  }

                  return SlideTransition(
                    position: _slideAnimation,
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(12.r),
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.wifi,
                              size: 16.sp,
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                            Gaps.gapSm8,
                            Expanded(
                              child: Text(
                                context.l10n.noInternetConnection,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onErrorContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            TextButton(
                              onPressed: _settings.openSettings,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                context.l10n.goToSettings,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
