import 'package:flutter/material.dart';

/// A widget that extends the functionality of the `Column` widget by providing additional features.
/// It ensures that the content within the column is scrollable if it exceeds the available height.
/// 
/// The `ExtendedColumn` widget takes a list of children widgets and wraps them in a `LayoutBuilder`,
/// `SingleChildScrollView`, `ConstrainedBox`, and `IntrinsicHeight` to achieve the desired behavior.
/// 
/// Example usage:
/// ```dart
/// ExtendedColumn(
///   children: [
///     Text('Widget 1'),
///     Text('Widget 2'),
///     Text('Widget 3'),
///   ],
/// )
/// ```
class ExtendedColumn extends StatefulWidget {
  /// Creates a new `ExtendedColumn` widget.
  /// 
  /// The `children` parameter is required and should contain a list of widgets to be displayed in the column.
  const ExtendedColumn({
    required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    super.key,
  });

  /// The list of children widgets to be displayed in the column.
  final List<Widget> children;

  /// The padding to be applied to the column.
  final EdgeInsetsGeometry padding;

  /// The alignment of the children widgets along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// The alignment of the children widgets along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  State<ExtendedColumn> createState() => _ExtendedColumnState();
}

class _ExtendedColumnState extends State<ExtendedColumn> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: widget.padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: widget.mainAxisAlignment,
                  crossAxisAlignment: widget.crossAxisAlignment,
                  children: widget.children,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
