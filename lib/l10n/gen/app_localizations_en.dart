// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Starter';

  @override
  String get noInternetTitle => 'Whoops!!';

  @override
  String get noInternetSubMessage => 'Please check your internet connection and try again.';

  @override
  String get goToSettings => 'Go to settings';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get more => 'More';

  @override
  String get logout => 'Logout';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get signInFailed => 'Sign In Failed';

  @override
  String get signUpFailed => 'Sign Up Failed';

  @override
  String get invalidEmail => 'Invalid Email';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get about => 'About';

  @override
  String get account => 'Account';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get requestFailed => 'Request Failed';

  @override
  String get checkEmail => 'Please Check Your Email';

  @override
  String get passwordResetSent => 'A password reset link has been sent to your dedicated email';

  @override
  String get didntReceiveEmail => 'Didn\'t receive the email?';

  @override
  String get characters => 'characters';

  @override
  String get enterPassword => 'Enter password';

  @override
  String passwordMaxLengthError(int maxLength) {
    return 'Maximum $maxLength characters allowed';
  }

  @override
  String get passwordIsRequired => 'Password is required';

  @override
  String passwordMinLengthError(int minLength) {
    return 'Password must be at least $minLength characters';
  }

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMustContainLettersAndDigits => 'Password must contain letters and digits';

  @override
  String get enterDigitsOnly => 'Enter digits only';

  @override
  String get phoneNumberTooShort => 'Phone number is too short';

  @override
  String get resend => 'Resend';

  @override
  String get searchCountry => 'Search Country';

  @override
  String get enterContactNumber => 'Enter your contact number';

  @override
  String get enterEmailReset => 'Enter your registered email address below and we\'ll send you a password reset email';

  @override
  String get submit => 'Submit';

  @override
  String get verification => 'Verification';

  @override
  String get logOut => 'Log Out';

  @override
  String get enterVerificationCode => 'Please enter your verification code';

  @override
  String get verificationCodeSent => 'The verification code has been sent to sample@mail.com';

  @override
  String get resendCode => 'Resend the Code';

  @override
  String get or => 'Or';

  @override
  String get sendCodeMobile => 'Send the verification code to your mobile number?';

  @override
  String get sendCode => 'Send the code';

  @override
  String get didntReceiveCode => 'Didn\'t receive the verification code?';

  @override
  String get agreeTo => 'By continuing, you agree to our ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get exploreApp => 'Explore The App';

  @override
  String get continueAction => 'Continue';

  @override
  String get disposableEmailError => 'Please use a valid email address. Disposable emails are not allowed.';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get enterEmailHint => 'Enter email';

  @override
  String get errorEnterEmail => 'Please enter your email';

  @override
  String get errorInvalidEmailAddress => 'Please enter a valid email';

  @override
  String get termsAndPrivacyConfirm => ' Terms and Conditions and confirm you have read our ';

  @override
  String get verify => 'Verify';

  @override
  String get verifyAccount => 'Verify Account';

  @override
  String get settingsPage => 'Settings Page';

  @override
  String get codeResendFailed => 'Code Resend Failed';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get errorEnterMobile => 'Please enter your mobile number';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get cancelLogout => 'Cancel & Logout';

  @override
  String get retryLater => 'Try again later or contact support if the issue persists.';

  @override
  String get chat => 'Chat';

  @override
  String get step1 => 'Step 1';

  @override
  String get step2 => 'Step 2';

  @override
  String get step3 => 'Step 3';

  @override
  String get passwordStrengthWeak => 'Weak password';

  @override
  String get passwordStrengthMedium => 'Medium strength';

  @override
  String get passwordStrengthStrong => 'Strong password';

  @override
  String get passwordNoSpacesError => 'Password cannot contain spaces';

  @override
  String get enterDescription => 'Enter description';

  @override
  String maxLengthError(int maxLength) {
    return 'Maximum $maxLength characters allowed';
  }

  @override
  String get noInternetConnection => 'No internet. Please check your network  connection.';

  @override
  String get sessionExpired => 'Session expired. Please log in again.';

  @override
  String get retry => 'Retry';

  @override
  String get serverConnectionError => 'Unable to connect to server. Please try again.';
}
