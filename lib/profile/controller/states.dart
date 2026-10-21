import 'package:testingapp/profile/profile.dart';

abstract class ProfileState {
  const ProfileState();
}

/// Represents the initial profile state.
class ProfileInitial extends ProfileState {}

/// Represents the profile state when loading.
class ProfileLoading extends ProfileState {}

/// Represents the profile state when profile is successfully loaded.
class ProfileLoaded extends ProfileState {
  /// Creates an instance of [ProfileLoaded] with the given [userProfile].
  const ProfileLoaded(this.userProfile);

  /// The user profile data.
  final UserProfile userProfile;
}

/// Represents the profile state when profile loading fails.
class ProfileLoadFailed extends ProfileState {
  /// Creates an instance of [ProfileLoadFailed] with the given [message].
  const ProfileLoadFailed(this.message);

  /// The error message associated with the profile loading failure.
  final String message;
}

/// Represents the profile state when profile is successfully updated.
class ProfileUpdated extends ProfileState {}

/// Represents the profile state when profile image is successfully uploaded.
class ProfileImageUpload extends ProfileLoading {
  ProfileImageUpload(this.message);

  final String message;
}

/// Represents the profile state when profile update fails.
class ProfileUpdateFailed extends ProfileState {
  /// Creates an instance of [ProfileUpdateFailed] with the given [message].
  const ProfileUpdateFailed(this.message);

  /// The error message associated with the profile update failure.
  final String message;
}

/// Represents the profile state when profile is successfully deleted.
class ProfileDeleted extends ProfileState {}

/// Represents the profile state when profile deletion fails.
class ProfileDeleteFailed extends ProfileState {
  /// Creates an instance of [ProfileDeleteFailed] with the given [message].
  const ProfileDeleteFailed(this.message);

  /// The error message associated with the profile deletion failure.
  final String message;
}
