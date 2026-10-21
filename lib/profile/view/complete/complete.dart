import 'dart:async';

import 'package:flutter/material.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/profile/profile.dart';
import 'package:testingapp/utils/utils.dart';

class CompleteProfileFlow extends StatefulWidget {
  const CompleteProfileFlow({super.key});

  @override
  State<CompleteProfileFlow> createState() => _CompleteProfileFlowState();
}

class _CompleteProfileFlowState extends State<CompleteProfileFlow> {
  late ProfileCompleteController _profileCompleteController;
  late StreamSubscription<ProfileState> _subscription;

  @override
  void initState() {
    _profileCompleteController = context.read<ProfileCompleteController>();
    _subscription = _profileCompleteController.state.listen(onAuthStateChanged);
    super.initState();
  }

  Future<void> onAuthStateChanged(ProfileState state) async {
    if (state is ProfileUpdateFailed && mounted) {
      await CommonDialog.alert(
        context,
        title: context.l10n.error,
        message: state.message,
      );
    }
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileCompleteController>();
    return StreamBuilder<ProfileState>(
      stream: controller.state,
      builder: (context, snapshot) {
        return AbsorbPointer(
          absorbing: snapshot.data is ProfileLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Text(context.l10n.signUp),
              automaticallyImplyLeading: false,
              leading: controller.currentStep > 0
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: controller.previousStep,
                    )
                  : null,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: LinearProgressIndicator(
                    value: controller.progress,
                    borderRadius: BorderRadius.circular(8),
                    minHeight: 5,
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: context.colorScheme.surface,
                        child: Center(child: Text(context.l10n.step1, style: context.bodyLarge())),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: context.colorScheme.surface,
                        child: Center(child: Text(context.l10n.step2, style: context.bodyLarge())),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: context.colorScheme.surface,
                        child: Center(child: Text(context.l10n.step3, style: context.bodyLarge())),
                      ),
                    ],
                  ),
                ),
                Gaps.gapMd16,
                CommonButton.primary(
                  isLoading: snapshot.data is ProfileLoading,
                  label: controller.currentStep == 2 ? context.l10n.exploreApp : context.l10n.continueAction,
                  onPressed: () {
                    if (controller.currentStep == 0) {
                      unawaited(controller.onSubmitFirstStep());
                    } else if (controller.currentStep == 1) {
                      unawaited(controller.onSubmitSecondStep());
                    } else {
                      unawaited(controller.onSubmitLastStep());
                    }
                  },
                ),
                const RelativeGap(mainAxisExtent: 0.05),
              ],
            ),
          ),
        );
      },
    );
  }
}
