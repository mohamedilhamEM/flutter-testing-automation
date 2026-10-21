import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Starter'**
  String get appName;

  /// Title for the no internet overlay
  ///
  /// In en, this message translates to:
  /// **'Whoops!!'**
  String get noInternetTitle;

  /// Sub-message for the no internet overlay
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get noInternetSubMessage;

  /// Label for the go to settings button
  ///
  /// In en, this message translates to:
  /// **'Go to settings'**
  String get goToSettings;

  /// Label for sign in button or title
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Label for sign up button or title
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Label for email input
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for password input
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Text for forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Prompt for users who already have an account
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Prompt for users who don't have an account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Label for first name input
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Label for last name input
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Title for home page
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Title for explore page
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// Title for settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Title for profile page
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Title for more page
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// Label for logout action
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Label for OK action
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Label for yes action
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Label for no action
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Error message when sign in fails
  ///
  /// In en, this message translates to:
  /// **'Sign In Failed'**
  String get signInFailed;

  /// Error message when sign up fails
  ///
  /// In en, this message translates to:
  /// **'Sign Up Failed'**
  String get signUpFailed;

  /// Error message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get invalidEmail;

  /// Title for help and support page
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Title for about page
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Title for account page
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Label for edit profile button
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Label for change password button
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Error title when request fails
  ///
  /// In en, this message translates to:
  /// **'Request Failed'**
  String get requestFailed;

  /// Title for email check instruction
  ///
  /// In en, this message translates to:
  /// **'Please Check Your Email'**
  String get checkEmail;

  /// Message confirming password reset link sent
  ///
  /// In en, this message translates to:
  /// **'A password reset link has been sent to your dedicated email'**
  String get passwordResetSent;

  /// Question for missing email
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the email?'**
  String get didntReceiveEmail;

  /// characters
  ///
  /// In en, this message translates to:
  /// **'characters'**
  String get characters;

  /// Hint text for password field
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// Validation error when the input exceeds the maximum allowed characters
  ///
  /// In en, this message translates to:
  /// **'Maximum {maxLength} characters allowed'**
  String passwordMaxLengthError(int maxLength);

  /// Error message when the password field is empty
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// Error message for short passwords
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {minLength} characters'**
  String passwordMinLengthError(int minLength);

  /// Error message for empty password
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// Error message when password doesn't contain both letters and digits
  ///
  /// In en, this message translates to:
  /// **'Password must contain letters and digits'**
  String get passwordMustContainLettersAndDigits;

  /// Validation error when non-numeric characters are entered
  ///
  /// In en, this message translates to:
  /// **'Enter digits only'**
  String get enterDigitsOnly;

  /// Validation error for incomplete phone numbers
  ///
  /// In en, this message translates to:
  /// **'Phone number is too short'**
  String get phoneNumberTooShort;

  /// Label for resend action
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// Search Country
  ///
  /// In en, this message translates to:
  /// **'Search Country'**
  String get searchCountry;

  /// Search Country
  ///
  /// In en, this message translates to:
  /// **'Enter your contact number'**
  String get enterContactNumber;

  /// Instruction for password reset
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email address below and we\'ll send you a password reset email'**
  String get enterEmailReset;

  /// Label for submit action
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Title for verification page
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// Label for logout action
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// Instruction to enter code
  ///
  /// In en, this message translates to:
  /// **'Please enter your verification code'**
  String get enterVerificationCode;

  /// Message confirming code sent
  ///
  /// In en, this message translates to:
  /// **'The verification code has been sent to sample@mail.com'**
  String get verificationCodeSent;

  /// Label for resend code action
  ///
  /// In en, this message translates to:
  /// **'Resend the Code'**
  String get resendCode;

  /// Divider text
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// Question to send code to mobile
  ///
  /// In en, this message translates to:
  /// **'Send the verification code to your mobile number?'**
  String get sendCodeMobile;

  /// Label for send code action
  ///
  /// In en, this message translates to:
  /// **'Send the code'**
  String get sendCode;

  /// Question for missing code
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the verification code?'**
  String get didntReceiveCode;

  /// Terms agreement prefix
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get agreeTo;

  /// Link text for terms
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Link text for privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Label for explore app action
  ///
  /// In en, this message translates to:
  /// **'Explore The App'**
  String get exploreApp;

  /// Label for continue action
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Error message for disposable email
  ///
  /// In en, this message translates to:
  /// **'Please use a valid email address. Disposable emails are not allowed.'**
  String get disposableEmailError;

  /// Text between auth separators
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// Hint text for email input
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmailHint;

  /// Error when email is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get errorEnterEmail;

  /// Error when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get errorInvalidEmailAddress;

  /// Text connecting terms and privacy policy
  ///
  /// In en, this message translates to:
  /// **' Terms and Conditions and confirm you have read our '**
  String get termsAndPrivacyConfirm;

  /// Label for verification button
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Label for account verification button
  ///
  /// In en, this message translates to:
  /// **'Verify Account'**
  String get verifyAccount;

  /// Title for settings page content
  ///
  /// In en, this message translates to:
  /// **'Settings Page'**
  String get settingsPage;

  /// Error message when resending code fails
  ///
  /// In en, this message translates to:
  /// **'Code Resend Failed'**
  String get codeResendFailed;

  /// Label for mobile number input
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// Error when mobile number is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your mobile number'**
  String get errorEnterMobile;

  /// Label for get started action
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Label for skip action
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Label for cancel and logout action
  ///
  /// In en, this message translates to:
  /// **'Cancel & Logout'**
  String get cancelLogout;

  /// Message for retrying later
  ///
  /// In en, this message translates to:
  /// **'Try again later or contact support if the issue persists.'**
  String get retryLater;

  /// Label for chat navigation item
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Label for step 1 placeholder
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get step1;

  /// Label for step 2 placeholder
  ///
  /// In en, this message translates to:
  /// **'Step 2'**
  String get step2;

  /// Label for step 3 placeholder
  ///
  /// In en, this message translates to:
  /// **'Step 3'**
  String get step3;

  /// Label for weak password strength
  ///
  /// In en, this message translates to:
  /// **'Weak password'**
  String get passwordStrengthWeak;

  /// Label for medium password strength
  ///
  /// In en, this message translates to:
  /// **'Medium strength'**
  String get passwordStrengthMedium;

  /// Label for strong password strength
  ///
  /// In en, this message translates to:
  /// **'Strong password'**
  String get passwordStrengthStrong;

  /// Error message when password contains whitespace
  ///
  /// In en, this message translates to:
  /// **'Password cannot contain spaces'**
  String get passwordNoSpacesError;

  /// Hint text for description input
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get enterDescription;

  /// Validation error when the input exceeds the maximum allowed characters
  ///
  /// In en, this message translates to:
  /// **'Maximum {maxLength} characters allowed'**
  String maxLengthError(int maxLength);

  /// Error message when the device has no network connectivity
  ///
  /// In en, this message translates to:
  /// **'No internet. Please check your network  connection.'**
  String get noInternetConnection;

  /// Error message when the auth token is invalid or expired
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get sessionExpired;

  /// Label for retry action button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Error message when the server is unreachable after retries
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to server. Please try again.'**
  String get serverConnectionError;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError('AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
