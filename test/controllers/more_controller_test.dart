import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/more/more.dart';

/// Mock class for AuthService
class MockAuthService extends Mock implements AuthService {}

/// Example test for ChangeNotifier-based controller.
/// 
/// This demonstrates how to:
/// - Test ChangeNotifier classes
/// - Mock dependencies with GetIt
/// - Verify method calls
void main() {
  late MoreController controller;
  late MockAuthService mockAuthService;
  late GetIt getIt;

  setUp(() async {
    // Reset GetIt before each test
    getIt = GetIt.instance;
    await getIt.reset();

    // Create mock
    mockAuthService = MockAuthService();

    // Register mock in GetIt
    getIt.registerSingleton<AuthService>(mockAuthService);

    // Create controller (it will use the mock from GetIt)
    controller = MoreController();
  });

  tearDown(() async {
    controller.dispose();
    await getIt.reset();
  });

  group('MoreController', () {
    test('should be a ChangeNotifier', () {
      // Assert - Controller extends ChangeNotifier
      expect(controller, isA<ChangeNotifier>());
    });

    test('logout should call AuthService.logout', () async {
      // Arrange - Setup mock to return successfully
      when(() => mockAuthService.logout()).thenAnswer((_) async => {});

      // Create a mock BuildContext (needed for logout method signature)
      final context = _MockBuildContext();

      // Act - Call logout
      await controller.logout(context);

      // Assert - Verify AuthService.logout was called once
      verify(() => mockAuthService.logout()).called(1);
    });

    test('should notify listeners when state changes', () {
      // Arrange - Track if listener was called
      var listenerCalled = false;
      controller..addListener(() {
        listenerCalled = true;
      })

      // Act - Trigger notification (if your controller has methods that call notifyListeners)
      ..notifyListeners();

      // Assert
      expect(listenerCalled, true);
    });
  });
}

/// Mock BuildContext for testing
class _MockBuildContext extends Mock implements BuildContext {}
