class UserProfile {
  UserProfile({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    this.isEmailVerified = false,
    this.isProfileCompleted = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uuid: json['uuid'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      isEmailVerified: (json['is_email_verified'] ?? false) as bool,
      isProfileCompleted: (json['is_profile_completed'] ?? false) as bool,
    );
  }

  String uuid;
  String firstName;
  String lastName;
  bool isEmailVerified = false;
  bool isProfileCompleted = false;
  // Add other fields as needed

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'firstName': firstName,
      'lastName': lastName,
      'is_email_verified': isEmailVerified,
      'is_profile_completed': isProfileCompleted,
    };
  }

  @override
  String toString() {
    return 'UserProfile{uuid: $uuid, firstName: $firstName, lastName: $lastName}';
  }
}

class UserProfileWithToken {
  UserProfileWithToken({required this.userProfile, required this.accessToken});

  factory UserProfileWithToken.fromJson(Map<String, dynamic> json) {
    return UserProfileWithToken(
      userProfile: UserProfile.fromJson(json),
      accessToken: json['access_token'] as String? ?? '',
    );
  }

  UserProfile userProfile;
  String accessToken;

  Map<String, dynamic> toJson() {
    final userProfileJson = userProfile.toJson();
    userProfileJson['access_token'] = accessToken;
    return userProfileJson;
  }

  @override
  String toString() {
    return 'UserProfileWithToken{userProfile: $userProfile, accessToken: $accessToken}';
  }
}

class UpdateProfileRequest {
  UpdateProfileRequest({
    required this.name,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequest(
      name: json['name'] as String,
    );
  }

  String name;
  // Add other fields as needed
  // For example:
  // String name;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  @override
  String toString() {
    return 'UpdateProfileRequest{name: $name}';
  }
}
