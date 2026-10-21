import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/utils/utils.dart';

enum ToastLength { short, long }

enum ToastGravity { top, bottom, center }

extension ToastExtension on BuildContext {
  /// Shows a toast message.
  ///
  /// [message] The text to display.
  /// [length] Duration to show the toast (short: 2s, long: 3.5s).
  /// [gravity] Position of the toast (top, bottom, center).
  /// [backgroundColor] Custom background color. Defaults to inverse surface.
  /// [textColor] Custom text color. Defaults to on inverse surface.
  void showToast(
    String message, {
    ToastLength length = ToastLength.short,
    ToastGravity gravity = ToastGravity.bottom,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final overlay = Overlay.of(this);
    OverlayEntry? entry;

    // Use theme-aware inverse surface colors for floating toast
    final defaultBg = colorScheme.inverseSurface;
    final defaultText = colorScheme.onInverseSurface;

    entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        length: length,
        gravity: gravity,
        backgroundColor: backgroundColor ?? defaultBg,
        textColor: textColor ?? defaultText,
        onDismiss: () {
          entry?.remove();
          entry = null;
        },
      ),
    );

    overlay.insert(entry!);
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({
    required this.message,
    required this.length,
    required this.gravity,
    required this.backgroundColor,
    required this.textColor,
    required this.onDismiss,
  });

  final String message;
  final ToastLength length;
  final ToastGravity gravity;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onDismiss;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    const fadeInDuration = Duration(milliseconds: 200);
    const fadeOutDuration = Duration(milliseconds: 200);
    final displayDuration = widget.length == ToastLength.short ? const Duration(seconds: 2) : const Duration(milliseconds: 3500);

    _controller = AnimationController(
      vsync: this,
      duration: fadeInDuration,
    );

    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    unawaited(_startAnimation(displayDuration, fadeOutDuration));
  }

  Future<void> _startAnimation(Duration displayDuration, Duration fadeOutDuration) async {
    await _controller.forward();
    await Future<void>.delayed(displayDuration);
    if (mounted) {
      await _controller.reverse(from: 1);
    }
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.gravity == ToastGravity.top ? 64 : null,
      bottom: widget.gravity == ToastGravity.bottom ? 64 : null,
      left: 16,
      right: 16,
      child: Center(
        child: widget.gravity == ToastGravity.center ? _buildToast() : SafeArea(child: _buildToast()),
      ),
    );
  }

  Widget _buildToast() {
    return FadeTransition(
      opacity: _opacity,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(24), // Pill shape
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            widget.message,
            style: context.bodyDefault(color: widget.textColor).medium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
