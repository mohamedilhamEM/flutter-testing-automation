import 'package:flutter/material.dart';
import 'package:testingapp/utils/widgets/widgets.dart';

/// A utility class for creating an overlay widget that dismisses the keyboard when tapped outside.
/// 
/// This class is typically used as a wrapper around other widgets to provide a gesture detector
/// that unFocuses the primary focus when tapped outside the wrapped widget.
class OverlayUtility extends StatelessWidget {
  const OverlayUtility({
    this.child, super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      
      /// Wraps the entire application with a connectivity overlay.
      /// This overlay globally displays a "No Internet" banner at the top 
      /// of the screen based on the state from `ConnectivityService`.
      child: ConnectivityOverlay(
        child: Builder(
          builder: (context) {
            return child ?? const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
