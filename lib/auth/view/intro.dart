import 'package:flutter/material.dart';
import 'package:testingapp/app/app.dart';
import 'package:testingapp/utils/utils.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExtendedColumn(
        children: [
          const RelativeGap(mainAxisExtent: 0.2),
          const AppLogo(aspectRatio: 16 / 9),
          const RelativeGap(mainAxisExtent: 0.1),
          CommonButton.primary(
            onPressed: () {
              Pages.signUp.go(context);
            },
            label: context.l10n.signUp,
          ),
          const Spacer(),
          const FixedGap(mainAxisExtent: 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(context.l10n.alreadyHaveAccount),
              Center(
                child: CommonButton.text(
                  onPressed: () {
                    Pages.signIn.go(context);
                  },
                  label: context.l10n.signIn,
                ),
              ),
            ],
          ),
          const RelativeGap(mainAxisExtent: 0.02),
        ],
      ),
    );
  }
}
