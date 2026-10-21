import 'package:flutter_test/flutter_test.dart';
import 'package:testingapp/profile/profile.dart';

import '../helpers/test_data.dart';

/// Example test for model serialization/deserialization.
/// 
/// This demonstrates how to test your data models to ensure
/// JSON parsing and serialization work correctly.
void main() {
  group('UserProfile', () {
    test('should create UserProfile from JSON', () {
      // Arrange - Using mock data from test_data.dart
      const json = mockUserProfileJson;

      // Act - Parse JSON into model
      final profile = UserProfile.fromJson(json);

      // Assert - Verify all fields are correctly parsed
      expect(profile.uuid, testUuid);
      expect(profile.firstName, 'John');
      expect(profile.lastName, 'Doe');
      expect(profile.isEmailVerified, true);
      expect(profile.isProfileCompleted, true);
    });

    test('should convert UserProfile to JSON', () {
      // Arrange - Create a UserProfile instance
      final profile = UserProfile.fromJson(mockUserProfileJson);

      // Act - Convert to JSON
      final json = profile.toJson();

      // Assert - Verify JSON structure
      expect(json['uuid'], testUuid);
      expect(json['firstName'], 'John');
      expect(json['lastName'], 'Doe');
      expect(json['is_email_verified'], true);
      expect(json['is_profile_completed'], true);
    });

    test('should handle missing fields with defaults', () {
      // Arrange - JSON with minimal required fields
      const json = {
        'uuid': testUuid,
        'firstName': '',
        'lastName': '',
        'is_email_verified': false,
        'is_profile_completed': false,
      };

      // Act
      final profile = UserProfile.fromJson(json);

      // Assert - Missing fields should have default values
      expect(profile.uuid, testUuid);
      expect(profile.firstName, '');
      expect(profile.lastName, '');
      expect(profile.isEmailVerified, false);
      expect(profile.isProfileCompleted, false);
    });

    test('should create full name from first and last name', () {
      // Arrange
      final profile = UserProfile.fromJson(mockUserProfileJson);

      // Act
      final fullName = '${profile.firstName} ${profile.lastName}';

      // Assert
      expect(fullName, 'John Doe');
    });
  });

  group('UserProfileWithToken', () {
    test('should create UserProfileWithToken from JSON', () {
      // Arrange
      const json = mockUserProfileWithTokenJson;

      // Act
      final profileWithToken = UserProfileWithToken.fromJson(json);

      // Assert
      expect(profileWithToken.userProfile.uuid, testUuid);
      expect(profileWithToken.accessToken, testToken);
      expect(profileWithToken.userProfile.firstName, 'John');
      expect(profileWithToken.userProfile.lastName, 'Doe');
    });

    test('should handle token correctly', () {
      // Arrange
      final profileWithToken = UserProfileWithToken.fromJson(mockUserProfileWithTokenJson);

      // Assert - Token should be present
      expect(profileWithToken.accessToken, isNotEmpty);
      expect(profileWithToken.accessToken, testToken);
    });

    test('should convert UserProfileWithToken to JSON', () {
      // Arrange
      final profileWithToken = UserProfileWithToken.fromJson(mockUserProfileWithTokenJson);

      // Act
      final json = profileWithToken.toJson();

      // Assert
      expect(json['uuid'], testUuid);
      expect(json['access_token'], testToken);
      expect(json['firstName'], 'John');
    });
  });
}
