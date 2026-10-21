import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/utils/utils.dart';

/// A theme-aware shimmer widget for loading states.
///
/// Uses `AppColors` extension to automatically adapt colors to the current theme.
///
/// ## Usage
/// ```dart
/// Standard rectangle
/// CommonShimmer(width: 100, height: 20);
///
/// Circular (Avatar)
/// CommonShimmer.circle(radius: 20);
///
/// Custom Content (Skeleton Layout)
/// CommonShimmer.content(
///   child: Column(
///     children: [
///       Container(height: 100, color: Colors.white),
///       Text('Loading...'),
///     ],
///   ),
/// );
/// ```
class CommonShimmer extends StatelessWidget {
  /// Creates a rectangular shimmer.
  const CommonShimmer({super.key, this.width, this.height, this.radius = 8, this.margin})
      : isCircle = false,
        child = null;

  /// Creates a circular shimmer.
  const CommonShimmer.circle({required this.radius, super.key, this.margin})
      : width = radius * 2,
        height = radius * 2,
        isCircle = true,
        child = null;

  /// Creates a shimmer wrapping custom content (e.g. for complex skeletons).
  ///
  /// The [child] should have solid backgrounds where you want the shimmer to be visible.
  const CommonShimmer.content({required Widget this.child, super.key, this.width, this.height, this.margin})
      : isCircle = false,
        radius = 0;

  final double? width;
  final double? height;
  final double radius;
  final bool isCircle;
  final EdgeInsetsGeometry? margin;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final shimmerWidget = Shimmer.fromColors(
      baseColor: GetIt.instance<ThemeServiceProvider>().shimmersColor,
      highlightColor: GetIt.instance<ThemeServiceProvider>().shimmerHighlightColor,
      child: child ??
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: context.colorScheme.onPrimary,
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isCircle ? null : BorderRadius.circular(radius),
            ),
          ),
    );

    if (margin != null) {
      return Padding(padding: margin!, child: shimmerWidget);
    }

    return shimmerWidget;
  }
}
