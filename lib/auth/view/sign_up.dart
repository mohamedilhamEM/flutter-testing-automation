import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/utils/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _phoneFocusNode;

  final String _countryCode = GetIt.instance<AppSettings>().countryCodes.first;

  final AuthService authService = GetIt.instance<AuthService>();

  /// Stream subscription for monitoring changes in the authentication state.
  late StreamSubscription<AuthState> _authStateSubscription;

  /// Initializes the state of the widget.
  /// Sets up the text controllers for email, password, and phone.
  /// Subscribes to the authentication state changes and calls the [onAuthStateChanged] method.
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _authStateSubscription = authService.onAuthStateChanges.listen(onAuthStateChanged);
    super.initState();
  }

  /// Callback function that is called when the authentication state changes.
  /// Shows an adaptive dialog with an error message if the authentication fails.
  /// The error message is obtained from the [AuthState] object.
  /// The dialog is dismissed when the user taps the 'OK' button.
  Future<void> onAuthStateChanged(AuthState state) async {
    if (state is AuthFailed && mounted) {
      TextInput.finishAutofillContext(shouldSave: false);
      await CommonDialog.alert(
        context,
        title: context.l10n.signUpFailed,
        message: state.message,
      );
    } else if (state is AuthSuccess) {
      TextInput.finishAutofillContext();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();
    unawaited(_authStateSubscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: authService.onAuthStateChanges,
      builder: (context, snapshot) {
        return AbsorbPointer(
          absorbing: snapshot.data is AuthLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Text(context.l10n.signUp),
            ),
            body: AutofillGroup(
              child: Form(
                key: _formKey,
                child: ExtendedColumn(
                  children: [
                    const RelativeGap(mainAxisExtent: 0.05),
                    AuthFormFields.email(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_phoneFocusNode);
                      },
                      title: context.l10n.email,
                    ),
                    Gaps.gapMd16,
                    AuthFormFields.password(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.done,
                      title: context.l10n.password,
                      requireStrict: false,
                      autofillHints: const [
                        AutofillHints.newPassword,
                      ],
                    ),
                    Gaps.gapMd16,
                    PhoneFormField(
                      phoneNumberController: _phoneController,
                      phoneFocusNode: _phoneFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      autofillHints: null,
                    ),
                    Gaps.gapLg24,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: context.l10n.agreeTo,
                          style: context.bodyDefault(),
                          children: [
                            TextSpan(
                              text: context.l10n.termsOfService,
                              style: context.bodyDefault(color: context.colorScheme.secondary).bold,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // TODO(ishanga): Add Terms and Conditions page
                                },
                            ),
                            TextSpan(text: context.l10n.termsAndPrivacyConfirm),
                            TextSpan(
                              text: context.l10n.privacyPolicy,
                              style: context.bodyDefault(color: context.colorScheme.secondary).bold,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // TODO(ishanga): Add Privacy Policy page
                                },
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                    Gaps.gapLg24,
                    CommonButton.primary(
                      isLoading: snapshot.data is AuthLoading,
                      label: context.l10n.verifyAccount,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          unawaited(
                            authService.signUp(
                              _emailController.text,
                              _passwordController.text,
                              _countryCode + _phoneController.text,
                            ),
                          );
                        }
                      },
                    ),
                    Gaps.gapXxl48,
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          context.l10n.orContinueWith,
                          style: context.bodyDefault(),
                        ),
                      ),
                    ),
                    Gaps.gapMd16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (Platform.isIOS)
                          Container(
                            decoration: BoxDecoration(
                              color: context.colorScheme.surface,
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: IconButton(
                              icon: const FaIcon(FontAwesomeIcons.apple),
                              onPressed: () {},
                            ),
                          ),
                        Gaps.gapMd16,
                        Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.surface,
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.google),
                            onPressed: () {},
                          ),
                        ),
                        Gaps.gapMd16,
                        Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.surface,
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.facebookF),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    Gaps.gapMd16,
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(context.l10n.alreadyHaveAccount),
                        Center(
                          child: CommonButton.text(
                            onPressed: () => Pages.signIn.go(context),
                            label: context.l10n.signIn,
                            textStyle: context.bodyDefault().bold,
                          ),
                        ),
                      ],
                    ),
                    const RelativeGap(mainAxisExtent: 0.02),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
