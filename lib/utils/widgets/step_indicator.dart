import 'package:flutter/material.dart';
import 'package:testingapp/utils/utils.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    required this.length,
    required this.currentIndex,
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final int length;
  final int currentIndex;

  Color backgroundColor(BuildContext context, int index) {
    if (currentIndex > index) {
      return context.colorScheme.primary;
    } else if (currentIndex == index) {
      return context.colorScheme.surface;
    } else {
      return context.colorScheme.surface;
    }
  }

  Color borderColor(BuildContext context, int index) {
    if (currentIndex > index) {
      return context.colorScheme.primary;
    } else if (currentIndex == index) {
      return context.colorScheme.primary;
    } else {
      return context.colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  Color textColor(BuildContext context, int index) {
    if (currentIndex > index) {
      return context.colorScheme.onPrimary;
    } else if (currentIndex == index) {
      return context.colorScheme.primary;
    } else {
      return context.colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: List.generate(4, (index) {
        return Row(
          children: [
            if (index != 0)
              Container(
                width: 24,
                height: 2,
                color: borderColor(context, index),
              ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor(context, index),
                border: Border.all(
                  color: borderColor(context, index),
                ),
              ),
              child: Center(
                child: Builder(
                  builder: (context) {
                    if (currentIndex > index) {
                      return FaIcon(
                        FontAwesomeIcons.check,
                        color: textColor(context, index),
                        size: 16,
                      );
                    } else {
                      return Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: textColor(context, index),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
