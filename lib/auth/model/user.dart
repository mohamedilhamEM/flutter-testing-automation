
/// This class represents a user session. It contains the user ID, access token, and the creation date of the session.
/// 
/// **Note:** This class is not generated from a JSON object. So don't replace it with a generated class.
/// 
/// Every time when new values are added to the class, the [Session.fromJson], [toJson] and [syncPreserveAccessToken] methods should be updated accordingly.
class Session {
  Session({
    required this.userId,
    required this.accessToken,
    required this.createdAt,
    this.isEmailVerified = false,
    this.isProfileCompleted = false,
  });

  /// Creates a [Session] object from a JSON map.
  /// 
  /// **Note:** Since [Session.fromJson] will called from various places in the application,
  /// with different JSON maps, it is important to handle the edge cases properly.
  /// 
  /// Returns a [Session] object with the parsed data.
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      userId: (json['id'] ?? '') as String,
      accessToken: (json['access_token'] ?? '') as String,
      createdAt: DateTime.tryParse((json['created_at'] ?? '') as String) ?? DateTime.now(),
      isEmailVerified: (json['is_email_verified'] ?? false) as bool,
      isProfileCompleted: (json['is_profile_completed'] ?? false) as bool,
    );
  }

  String userId;
  String accessToken;
  DateTime createdAt;
  bool isEmailVerified = false;
  bool isProfileCompleted = false;

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'access_token': accessToken,
      'created_at': createdAt.toIso8601String(),
      'is_email_verified': isEmailVerified,
      'is_profile_completed': isProfileCompleted,
    };
  }

  @override
  String toString() {
    return 'Session(userId: $userId, accessToken: $accessToken, createdAt: $createdAt, isEmailVerified: $isEmailVerified, isProfileCompleted: $isProfileCompleted)';
  }

  /// Syncs and preserves the access token of a session.
  /// 
  /// This method takes a [Session] object as input and returns a new [Session] object with the same properties, except for the access token.
  /// The access token of the input session is replaced with the current access token.
  /// 
  /// Parameters:
  /// - [session]: The session object to sync and preserve the access token.
  /// 
  /// Returns:
  /// A new [Session] object with the same properties as the input session, except for the access token.
  Session syncPreserveAccessToken(Session session) {
    return Session(
      userId: session.userId,
      accessToken: accessToken,
      createdAt: session.createdAt,
      isEmailVerified: session.isEmailVerified,
      isProfileCompleted: session.isProfileCompleted,
    );
  }
}
