import 'package:flutter/material.dart';
import 'package:gap/gap.dart' as gap_pkg;
import 'package:testingapp/utils/utils.dart';

/// A widget that represents a relative gap in the main axis of a layout.
///
/// The [RelativeGap] widget is used to create a gap with a size relative to the
/// main axis extent of the parent layout. It is commonly used to add spacing
/// between widgets in a layout.
///
/// The [mainAxisExtent] parameter specifies the relative size of the gap
/// compared to the main axis extent of the parent layout. It should be a value
/// between 0.0 and 1.0, where 0.0 represents no gap and 1.0 represents a gap
/// equal to the full main axis extent.
///
/// Example usage:
///
/// ```dart
/// RelativeGap(
///   mainAxisExtent: 0.2,
/// )
/// ```
class RelativeGap extends StatelessWidget {
  const RelativeGap({
    required this.mainAxisExtent, super.key,
  });

  final double mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    return gap_pkg.Gap(
      MediaQuery.sizeOf(context).height * mainAxisExtent,
    );
  }
}

/// A widget that represents a fixed gap with a specific main axis extent.
/// Creates a [FixedGap] widget.
///
/// The [mainAxisExtent] parameter specifies the extent of the gap along the main axis.
/// The extent of the gap along the main axis.
/// 
/// Example usage:
/// 
/// ```dart
///   Column(
///    children: [
///     const Text('Item 1'),
///     Gap.gapMd16,
///     const Text('Item 2'),
///    ],
///   )
/// ```
/// 
/// 
class FixedGap extends StatelessWidget {
  const FixedGap({
    required this.mainAxisExtent, super.key,
  });

  final double mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    return gap_pkg.Gap(
      mainAxisExtent,
    );
  }
}

/// Predefined gap sizes for consistent spacing throughout the app.
/// Naming matches AppSpacing for consistency.
///
/// Usage:
/// ```dart
/// Column(
///   children: [
///     Text('Title'),
///     Gap.gapMd16,
///     Text('Content'),
///     Gap.gapLg24,
///     ElevatedButton(onPressed: () {}, child: Text('Action')),
///   ],
/// )
/// ```
class Gaps {
  Gaps._();
  /// 4px gap (extra small)
  static gap_pkg.Gap get gapXs4 => gap_pkg.Gap(AppSpacing.xs4);

  /// 8px gap (small)
  static gap_pkg.Gap get gapSm8 => gap_pkg.Gap(AppSpacing.sm8);

  /// 12px gap (medium)
  static gap_pkg.Gap get gapMd12 => gap_pkg.Gap(AppSpacing.md12);

  /// 16px gap (medium)
  static gap_pkg.Gap get gapMd16 => gap_pkg.Gap(AppSpacing.md16);

  /// 24px gap (large)
  static gap_pkg.Gap get gapLg24 => gap_pkg.Gap(AppSpacing.lg24);

  /// 32px gap (extra large)
  static gap_pkg.Gap get gapXl32 => gap_pkg.Gap(AppSpacing.xl32);

  /// 40px gap (extra large)
  static gap_pkg.Gap get gapXl40 => gap_pkg.Gap(AppSpacing.xl40);

  /// 48px gap (extra extra large)
  static gap_pkg.Gap get gapXxl48 => gap_pkg.Gap(AppSpacing.xxl48);
}
