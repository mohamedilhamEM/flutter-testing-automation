import 'package:flutter/material.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/utils/utils.dart';

/// A utility class for showing styled bottom sheets.
///
/// ## Usage
/// ```dart
/// Simple bottom sheet
/// CommonBottomSheet.show(
///   context,
///   child: MyContent(),
/// );
///
/// With title
/// CommonBottomSheet.show(
///   context,
///   title: 'Select Option',
///   child: MyContent(),
/// );
///
///  Modal (must dismiss explicitly)
/// final result = await CommonBottomSheet.showModal<String>(
///   context,
///   title: 'Choose',
///   child: MyPicker(),
/// );
/// ```
class CommonBottomSheet {
  CommonBottomSheet._();

  /// Shows a bottom sheet with optional title and drag handle.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool showDragHandle = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _BottomSheetContent(
        title: title,
        showDragHandle: showDragHandle,
        height: height,
        child: child,
      ),
    );
  }

  /// Shows a modal bottom sheet that takes up most of the screen.
  static Future<T?> showModal<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool showDragHandle = true,
    bool isDismissible = true,
    double heightFactor = 0.9,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: heightFactor,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _BottomSheetContent(
          title: title,
          showDragHandle: showDragHandle,
          scrollController: scrollController,
          child: child,
        ),
      ),
    );
  }
}

class _BottomSheetContent extends StatelessWidget {
  const _BottomSheetContent({
    required this.child,
    this.title,
    this.showDragHandle = true,
    this.height,
    this.scrollController,
  });

  final Widget child;
  final String? title;
  final bool showDragHandle;
  final double? height;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) ...[
            Gaps.gapMd16,
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorScheme.outline.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
          if (title != null) ...[
            Gaps.gapMd16,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title!,
                // style: context.h1().bold,
                style: context.headline1(),
              ),
            ),
          ],
          Gaps.gapMd16,
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
