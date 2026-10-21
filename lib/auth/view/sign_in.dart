import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testingapp/app/app.dart';

import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/utils/utils.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  final AuthService authService = GetIt.instance<AuthService>();

  /// Stream subscription for monitoring changes in the authentication state.
  late StreamSubscription<AuthState> _authStateSubscription;

  /// Initializes the state of the widget.
  /// Sets up the text controllers for email, password, and phone.
  /// Subscribes to the authentication state changes and calls the [onAuthStateChanged] method.
  @override
  void initState() {
    _emailController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
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
        title: context.l10n.signInFailed,
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
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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
              title: Text(context.l10n.signIn),
            ),
            body: AutofillGroup(
              child: Form(
                key: _formKey,
                child: ExtendedColumn(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      child: AppLogo(aspectRatio: 16 / 9),
                    ),
                    AuthFormFields.email(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
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
                    ),
                    Gaps.gapMd16,
                    Center(
                      child: CommonButton.text(
                        onPressed: () => Pages.forgotPassword.go(context),
                        label: context.l10n.forgotPassword,
                        textStyle: context.bodyDefault(),
                      ),
                    ),
                    Gaps.gapMd16,
                    CommonButton.primary(
                      label: context.l10n.signIn,
                      isLoading: snapshot.data is AuthLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          unawaited(
                            authService.login(
                              _emailController.text,
                              _passwordController.text,
                            ),
                          );
                        }
                      },
                    ).pad(const EdgeInsets.all(16)),
                    Gaps.gapXxl48,
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(context.l10n.orContinueWith, style: context.bodyDefault()),
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
                      Text(context.l10n.dontHaveAccount),
                      Center(
                        child: CommonButton.text(
                          onPressed: () => Pages.signUp.go(context),
                          label: context.l10n.signUp,
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
