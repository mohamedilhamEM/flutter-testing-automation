import 'package:flutter/material.dart';
import 'package:testingapp/utils/utils.dart';

/// A circular progress indicator that can be styled with a custom color.
///
/// Example:
/// ```dart
/// CommonCircularLoader(color: Colors.white)
/// CommonCircularLoader.dark()
/// ```
class CommonCircularLoader extends StatelessWidget {
  /// Creates a circular loader with optional custom color.
  const CommonCircularLoader({super.key, this.color}) : isDark = false;
  
  /// Creates a circular loader with dark styling.
  const CommonCircularLoader.dark({super.key}) : isDark = true, color = null;
  
  final bool isDark;
  
  /// Custom color for the progress indicator. If null, uses color scheme defaults.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // Determine the effective color to use
    final effectiveColor = color ??
        (isDark
            ? context.colorScheme.onPrimary.withValues(alpha: 0.5)
            : context.colorScheme.onSecondary.withValues(alpha: 0.5));
    
    return SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(        
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
      ),
    );
  }
}
