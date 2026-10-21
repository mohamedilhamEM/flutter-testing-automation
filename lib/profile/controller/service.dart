import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testingapp/profile/profile.dart';

/// A service class that extends [ProfileRepository].
///
/// This class provides user profile functionality with reactive state management capabilities,
/// allowing UI components to rebuild when profile data changes.
///
/// Use this service to:
/// - Fetch user profile information
/// - Update user profile data
/// - Listen for changes to the user profile
class UserProfileService extends ProfileRepository with ChangeNotifier {
  /// Controller for profile-related state management.
  /// Creates a [BehaviorSubject] that manages the state of the profile.
  /// The stream starts with an initial state of [ProfileInitial].
  final BehaviorSubject<ProfileState> _profileStateSubject = BehaviorSubject<ProfileState>.seeded(ProfileInitial());

  /// Holds the user's profile information.
  /// This private field is used to cache the user profile data,
  /// and can be null if the user is not logged in or the profile has not been loaded yet.
  UserProfile? _userProfile;

  /// Gets the current user profile.
  ///
  /// Returns the current [UserProfile] instance if available, or `null` if no profile is set.
  UserProfile? get userProfile => _userProfile;

  /// Sets the user profile and notifies listeners of the change.
  /// 
  /// This setter updates the private [_userProfile] field and triggers a rebuild
  /// of any widgets that are listening to this service.
  ///
  /// [userProfile] The new user profile to be set.
  /// If `null`, it indicates that the user is not logged in or the profile has not been loaded.
  set userProfile(UserProfile? userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }

  /// Returns the current [ProfileState] from the subject value.
  ///
  /// This getter provides access to the current state of the profile without having to subscribe to the stream.
  ProfileState get currentProfileState => _profileStateSubject.value;

  /// Returns a stream that emits [ProfileState] updates.
  ///
  /// This stream allows listeners to receive real-time updates about changes in the profile state.
  /// It's derived from the private [_profileStateSubject] behavior subject.
  Stream<ProfileState> get profileStateStream => _profileStateSubject.stream;

  /// Dispose method to release resources.
  /// This is called when the widget is removed from the tree permanently.
  /// It closes the profile state subject, preventing memory leaks.
  @override
  void dispose() {
    unawaited(_profileStateSubject.close());
    super.dispose();
  }

  /// Fetches the user profile from the backend.
  ///
  /// This asynchronous method attempts to retrieve the user profile information
  /// and updates the profile state accordingly:
  /// - Sets [ProfileLoading] state when the fetch starts.
  /// - Sets [ProfileLoaded] state with the retrieved profile if successful.
  /// - Sets [ProfileLoadFailed] state with appropriate error message if:
  ///   - No profile data is available
  ///   - An exception occurs during the fetch operation
  ///
  /// The fetch operation uses the [getProfile] method to retrieve the profile data.
  Future<void> fetchUserProfile() async {
    _profileStateSubject.add(ProfileLoading());
    try {
      final response = await getProfile();
      userProfile = response;
      _profileStateSubject.add(ProfileLoaded(response));
    } on Object catch (e) {
      _profileStateSubject.add(ProfileLoadFailed(e.toString()));
    }
  }

  /// Updates the user profile with the provided information.
  ///
  /// This method sends an [UpdateProfileRequest] to the server to modify user profile data.
  /// The method is asynchronous and returns a [Future] that completes when the update operation is finished.
  ///
  /// Parameters:
  /// - [request]: An [UpdateProfileRequest] object containing the profile data to be updated.
  Future<void> updateUserProfile(UpdateProfileRequest request) async {
    _profileStateSubject.add(ProfileLoading());
    try {
      final response = await updateProfile(request);
      userProfile = response;
      _profileStateSubject.add(ProfileLoaded(response));
    } on Object catch (e) {
      _profileStateSubject.add(ProfileLoadFailed(e.toString()));
    }
  }

  /// Delete the user account permanently.
  ///
  /// This operation cannot be undone and will remove all user data associated with the account.
  /// Requires the user to be authenticated.
  ///
  /// Returns a [Future] that completes when the account deletion is successful.
  Future<void> deleteUserAccount() async {
    _profileStateSubject.add(ProfileLoading());
    try {
      await deleteProfile();
      userProfile = null;
      _profileStateSubject.add(ProfileDeleted());
    } on Object catch (e) {
      _profileStateSubject.add(ProfileDeleteFailed(e.toString()));
    }
  }
}
