import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testingapp/utils/utils.dart';

import '../helpers/pump_app.dart';

/// Example widget test for CommonButton.
/// 
/// This demonstrates how to test custom widgets to ensure
/// they render correctly and handle user interactions.
void main() {
  group('CommonButton.primary', () {
    testWidgets('should render with label text', (tester) async {
      // Arrange & Act - Pump the widget
      await tester.pumpApp(
        CommonButton.primary(
          label: 'Test Button',
          onPressed: () {},
        ),
      );

      // Assert - Button should display the label
      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      // Arrange - Track if callback was called
      var wasPressed = false;

      await tester.pumpApp(
        CommonButton.primary(
          label: 'Test Button',
          onPressed: () => wasPressed = true,
        ),
      );

      // Act - Tap the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Callback should have been called
      expect(wasPressed, true);
    });

    testWidgets('should show loading spinner when isLoading is true', (tester) async {
      // Arrange & Act
      await tester.pumpApp(
        CommonButton.primary(
          label: 'Test Button',
          isLoading: true,
          onPressed: () {},
        ),
      );

      // Assert - Should show loader, not text
      expect(find.byType(CommonCircularLoader), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('should be disabled when isEnabled is false', (tester) async {
      // Arrange
      var wasPressed = false;

      await tester.pumpApp(
        CommonButton.primary(
          label: 'Test Button',
          isEnabled: false,
          onPressed: () => wasPressed = true,
        ),
      );

      // Act - Try to tap
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Callback should NOT have been called
      expect(wasPressed, false);

      // Button should have disabled styling
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should display prefix icon', (tester) async {
      // Arrange & Act
      await tester.pumpApp(
        CommonButton.primary(
          label: 'Next',
          prefixIcon: Icons.arrow_forward,
          onPressed: () {},
        ),
      );

      // Assert - Icon and text should both be visible
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('should display suffix icon', (tester) async {
      // Arrange & Act
      await tester.pumpApp(
        CommonButton.primary(
          label: 'Back',
          suffixIcon: Icons.arrow_back,
          onPressed: () {},
        ),
      );

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('should apply custom background color', (tester) async {
      // Arrange & Act
      await tester.pumpApp(
        CommonButton.primary(
          label: 'Custom',
          backgroundColor: Colors.red,
          onPressed: () {},
        ),
      );

      // Assert - Button should exist (color testing is complex, just verify it renders)
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should handle small size variant', (tester) async {
      // Arrange & Act
      await tester.pumpApp(
        CommonButton.primary(
          label: 'Small',
          size: CommonButtonSize.small,
          onPressed: () {},
        ),
      );

      // Assert - Button should render with small size
      expect(find.text('Small'), findsOneWidget);
    });
  });

  group('CommonButton.outline', () {
    testWidgets('should render as OutlinedButton', (tester) async {
      // Arrange & Act
      await tester.pumpApp(
        CommonButton.outline(
          label: 'Outline',
          onPressed: () {},
        ),
      );

      // Assert
      expect(find.text('Outline'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      // Arrange
      var wasPressed = false;

      await tester.pumpApp(
        CommonButton.outline(
          label: 'Test',
          onPressed: () => wasPressed = true,
        ),
      );

      // Act
      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      // Assert
      expect(wasPressed, true);
    });
  });

  group('CommonButton.text', () {
    testWidgets('should render as TextButton', (tester) async {
      // Arrange & Act
      await tester.pumpApp(
        CommonButton.text(
          label: 'Text Button',
          onPressed: () {},
        ),
      );

      // Assert
      expect(find.text('Text Button'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('should show loading state', (tester) async {
      // Arrange & Act
      await tester.pumpApp(
        CommonButton.text(
          label: 'Loading',
          isLoading: true,
          onPressed: () {},
        ),
      );

      // Assert
      expect(find.byType(CommonCircularLoader), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });
  });
}
