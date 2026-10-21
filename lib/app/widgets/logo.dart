import 'package:flutter/material.dart';
import 'package:testingapp/utils/utils.dart';

/// A widget that displays the app logo.
///
/// The [AppLogo] widget takes in an [aspectRatio] parameter to control the aspect ratio of the logo.
/// It renders an [AspectRatio] widget with the specified aspect ratio, containing a [Placeholder] widget
/// with a padding of 8 pixels and a child [Text] widget displaying the text 'Logo goes here'.
class AppLogo extends StatelessWidget {
  const AppLogo({
    required this.aspectRatio,
    super.key,
  });
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Hero(
        tag: 'app-logo',
        child: Material(
          child: Placeholder(
            color: context.colorScheme.secondary,
            fallbackHeight: 100,
            fallbackWidth: 100,
            child: const Text('Logo goes here'),
          ),
        ),
      ),
    );
  }
}
