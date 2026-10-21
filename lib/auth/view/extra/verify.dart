import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/auth/auth.dart';
import 'package:testingapp/utils/utils.dart';

class CodeVerificationPage extends StatefulWidget {
  const CodeVerificationPage({super.key});

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  final AuthService _authService = GetIt.instance<AuthService>();
  late final TextEditingController _codeController;

  /// Stream subscription for monitoring changes in the authentication state.
  late StreamSubscription<AuthState> _authStateSubscription;

  /// Initializes the state of the widget.
  /// Subscribes to the authentication state changes and calls the [onAuthStateChanged] method.
  @override
  void initState() {
    _codeController = TextEditingController();
    _authStateSubscription = _authService.onAuthStateChanges.listen(onAuthStateChanged);
    super.initState();
  }

  /// Callback function that is called when the authentication state changes.
  /// Shows an adaptive dialog with an error message if the authentication fails.
  /// The error message is obtained from the [AuthState] object.
  /// The dialog is dismissed when the user taps the 'OK' button.
  Future<void> onAuthStateChanged(AuthState state) async {
    if (state is AuthCodeVerificationFailed && mounted) {
      await CommonDialog.alert(
        context,
        title: context.l10n.error,
        message: state.message,
      );
    } else if (state is AuthCodeResendFailed) {
      await CommonDialog.alert(
        context,
        title: context.l10n.error,
        message: state.message,
      );
    }
  }

  @override
  void dispose() {
    unawaited(_authStateSubscription.cancel());
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: context.headline1(color: context.colorScheme.onSurface),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colorScheme.primary, width: 2),
      ),
    );
    final followingPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
    );
    return StreamBuilder<AuthState>(
      stream: _authService.onAuthStateChanges,
      builder: (context, snapshot) {
        return AbsorbPointer(
          absorbing: snapshot.data is AuthLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Text(context.l10n.verification),
              actions: [
                CommonButton.text(
                  onPressed: () async {
                    await _authService.logout();
                  },
                  label: context.l10n.logOut,
                  foregroundColor: context.colorScheme.error,
                ),
              ],
            ),
            body: ExtendedColumn(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const RelativeGap(mainAxisExtent: 0.05),
                Text(
                  context.l10n.enterVerificationCode,
                  textAlign: TextAlign.center,
                  style: context.headline1(),
                ),
                Gaps.gapMd16,
                Text(
                  context.l10n.verificationCodeSent,
                  textAlign: TextAlign.center,
                  style: context.bodyDefault(),
                ),
                Gaps.gapXxl48,
                SizedBox(
                  width: double.infinity,
                  child: Pinput(
                    autofocus: true,
                    controller: _codeController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    followingPinTheme: followingPinTheme,                   
                  ),
                ),
                Gaps.gapXxl48,
                CommonButton.primary(
                  size: CommonButtonSize.small,
                  isLoading: snapshot.data is AuthLoading,
                  label: context.l10n.verify,
                  onPressed: () async {
                    await _authService.verify(_codeController.text);
                  },
                ),
                Gaps.gapMd16,
                const Spacer(),
                Text(
                  context.l10n.didntReceiveCode,
                  textAlign: TextAlign.center,
                  style: context.bodyDefault(),
                ),
                Gaps.gapXs4,
                CommonButton.text(
                  onPressed: _authService.resendVerificationCode,
                  label: context.l10n.resendCode,
                ),
                Gaps.gapMd16,
                Text(
                  context.l10n.or,
                  textAlign: TextAlign.center,
                  style: context.bodyDefault(),
                ),
                Gaps.gapMd16,
                Text(
                  context.l10n.sendCodeMobile,
                  textAlign: TextAlign.center,
                  style: context.bodyDefault(),
                ),
                Gaps.gapXs4,
                CommonButton.text(
                  onPressed: () {},
                  label: context.l10n.sendCode,
                ),
                const RelativeGap(mainAxisExtent: 0.02),
              ],
            ),
          ),
        );
      },
    );
  }
}
