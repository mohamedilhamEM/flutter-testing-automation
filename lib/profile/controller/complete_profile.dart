import 'dart:async';

import 'package:flutter/material.dart';
import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/profile/profile.dart';
import 'package:testingapp/utils/utils.dart';

/// A controller class for managing a multi-step profile completion process.
///
/// This controller handles the state and navigation between different steps of the profile
/// completion process, manages form validation for each step, and coordinates with the
/// Profile Repository to update user profile information.
///
/// ## Features:
/// * Manages a 3-step profile completion flow
/// * Handles page navigation between steps
/// * Provides form validation for each step
/// * Broadcasts profile state updates through a stream
/// * Calculates progress through the completion process
///
/// Remember to dispose the controller when it's no longer needed to prevent memory leaks.
class ProfileCompleteController extends ProfileRepository with ChangeNotifier {
  ProfileCompleteController({UserProfile? currentProfile}) : super() {
    // Initialize the text editing controllers with the current profile data
    // This allows the user to see their existing information when they start the profile completion process.
    // If the current profile is null, the text fields will be empty.
    // In case of user exit the app and come back, the data will be pre-filled.
    _firstNameController = TextEditingController(text: currentProfile?.firstName);
    _lastNameController = TextEditingController(text: currentProfile?.lastName);
    // Initialize the additional text editing controllers for other fields as needed.
    // For example:
    // _emailController = TextEditingController(text: currentProfile?.email);
    // _phoneController = TextEditingController(text: currentProfile?.phone);
  }

  /// Total number of steps in the profile completion process.
  /// The [stepCount] is used to determine the total number of steps in the stepper widget.
  static const int stepCount = 3;

  /// Current step index in the profile completion process.
  /// The [_currentStep] is used to track the current step being displayed.
  /// It is zero-based, so the first step is 0 and the last step is [stepCount] - 1.
  int _currentStep = 0;

  /// Controller for navigating through profile completion pages.
  /// 
  /// The [_pageController] manages the page transitions in a PageView widget.
  /// 
  /// The [_stateController] broadcasts state updates to listeners, allowing 
  /// components to react to changes in the profile completion process.
  final PageController _pageController = PageController();
  final StreamController<ProfileState> _stateController = StreamController<ProfileState>.broadcast();

  /// The current index indicating the active step in the profile completion process.
  /// The [pageController] responsible for managing the page navigation.
  /// A stream providing real-time updates of the [ProfileState].
  /// The proportion of completed steps, represented as a value between 0.0 and 1.0,
  /// calculated by dividing the current step index plus one by the total step count.
  int get currentStep => _currentStep;
  PageController get pageController => _pageController;
  Stream<ProfileState> get state => _stateController.stream;
  double get progress => (_currentStep + 1) / stepCount;

  /// Form key references used to manage validation states across profile completion steps.
  ///
  /// [_stepOneFormKey] controls the first step of the profile completion form,
  /// allowing for validation of user inputs before proceeding.
  ///
  /// [_stepTwoFormKey] controls the second step of the profile completion form,
  /// enabling validation of inputs before final submission.
  final _stepOneFormKey = GlobalKey<FormState>();
  final _stepTwoFormKey = GlobalKey<FormState>();

  /// Form keys for the profile completion steps.
  ///
  /// [stepOneFormKey] is the key for the first step form.
  /// [stepTwoFormKey] is the key for the second step form.
  /// 
  /// These keys are used to validate and control the respective forms.
  GlobalKey<FormState> get stepOneFormKey => _stepOneFormKey;
  GlobalKey<FormState> get stepTwoFormKey => _stepTwoFormKey;

  // Example Fields for the steps
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  /// Text editing controllers for managing user input in the profile completion steps.
  /// These controllers are used to retrieve and validate user input data.
  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;

  /// Advances to the next step in the profile completion process if there are more steps.
  ///
  /// This method increments the current step index and animates to the next page
  /// in the PageView controlled by [_pageController]. The animation duration is set
  /// to 300 milliseconds with an easeInOut curve. After changing the page,
  /// it notifies listeners to update the UI.
  ///
  /// If the current step is already the last step, this method does nothing.
  void nextStep() {
    if (_currentStep < stepCount - 1) {
      _currentStep++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  /// Navigates to the previous step in the profile completion process.
  /// 
  /// Decreases the current step index and animates to the previous page
  /// if not on the first step already. After changing the step, notifies
  /// listeners to update the UI.
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  Future<void> onSubmitFirstStep() async {
    _stateController.add(ProfileLoading());
    try {
      if (_stepOneFormKey.currentState!.validate()) {
        // Add logic to handle the first step submission

        _stateController.add(ProfileUpdated());
      } else {
        _stateController.add(const ProfileUpdateFailed('Please fill in all the fields'));
        return;
      }
      nextStep();
    } on Object catch (e) {
      _stateController.add(ProfileUpdateFailed(e.toString()));
    }
  }

  Future<void> onSubmitSecondStep() async {
    _stateController.add(ProfileLoading());
    try {
      if (_stepTwoFormKey.currentState!.validate()) {
        // Add logic to handle the second step submission here

        _stateController.add(ProfileUpdated());
      } else {
        _stateController.add(const ProfileUpdateFailed('Please fill in all the fields'));
        return;
      }
      nextStep();
    } on Object catch (e) {
      _stateController.add(ProfileUpdateFailed(e.toString()));
    }
  }

  Future<void> onSubmitLastStep() async {
    _stateController.add(ProfileLoading());
    await GetIt.instance<AuthService>().refreshSession();
    _stateController.add(ProfileUpdated());
  }

  /// Disposes resources when the controller is no longer needed.
  /// 
  /// This method is called when the controller is being removed from memory.
  /// It disposes the [_pageController] and closes the [_stateController] stream
  /// before calling the parent class's dispose method.
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    // Dispose other text editing controllers if they are used
    _pageController.dispose();
    unawaited(_stateController.close());
    super.dispose();
  }
}
