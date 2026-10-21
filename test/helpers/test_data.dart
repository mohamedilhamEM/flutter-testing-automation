/// Mock data and fixtures for testing.
/// 
/// This file contains sample data used across multiple test files.
/// Update these values to match your app's data structure.
library;

// ─────────────────────────────────────────────────────
// AUTH TEST DATA
// ─────────────────────────────────────────────────────

const testEmail = 'test@example.com';
const testPassword = 'Test123!@#';
const testToken = 'mock_jwt_token_12345';
const testUuid = 'user_uuid_123';

// ─────────────────────────────────────────────────────
// USER PROFILE TEST DATA
// ─────────────────────────────────────────────────────

const Map<String, dynamic> mockUserProfileJson = {
  'uuid': testUuid,
  'firstName': 'John',
  'lastName': 'Doe',
  'is_email_verified': true,
  'is_profile_completed': true,
};

const Map<String, dynamic> mockUserProfileWithTokenJson = {
  'uuid': testUuid,
  'access_token': testToken,
  'firstName': 'John',
  'lastName': 'Doe',
  'is_email_verified': true,
  'is_profile_completed': true,
};

// ─────────────────────────────────────────────────────
// API RESPONSE TEST DATA
// ─────────────────────────────────────────────────────

const Map<String, dynamic> mockSuccessResponse = {
  'result': true,
  'message': 'Success',
  'payload': mockUserProfileWithTokenJson,
};

const Map<String, dynamic> mockFailureResponse = {
  'result': false,
  'message': 'Invalid credentials',
  'error': 'INVALID_CREDENTIALS',
};

const Map<String, dynamic> mockValidationErrorResponse = {
  'result': false,
  'message': 'Validation failed',
  'errors': {
    'email': ['Email is required'],
    'password': ['Password must be at least 8 characters'],
  },
};

// ─────────────────────────────────────────────────────
// REQUEST TEST DATA
// ─────────────────────────────────────────────────────

const Map<String, dynamic> mockLoginRequest = {
  'email': testEmail,
  'password': testPassword,
  'device_id': 'test_device_123',
  'device_platform': 'iOS',
};

const Map<String, dynamic> mockRegisterRequest = {
  'email': testEmail,
  'password': testPassword,
  'first_name': 'John',
  'last_name': 'Doe',
  'phone': '+1234567890',
  'device_id': 'test_device_123',
  'device_platform': 'iOS',
};
