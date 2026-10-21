import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testingapp/utils/utils.dart';

import '../helpers/pump_app.dart';

void main() {
  group('Autofill Support Tests', () {
    late TextEditingController emailController;
    late TextEditingController passwordController;
    late TextEditingController phoneController;
    late FocusNode phoneFocusNode;

    setUp(() {
      emailController = TextEditingController();
      passwordController = TextEditingController();
      phoneController = TextEditingController();
      phoneFocusNode = FocusNode();
    });

    tearDown(() {
      emailController.dispose();
      passwordController.dispose();
      phoneController.dispose();
      phoneFocusNode.dispose();
    });

    testWidgets('CommonTextField correctly forwards autofillHints to TextField', (tester) async {
      const hints = [AutofillHints.name, AutofillHints.givenName];

      await tester.pumpApp(
        Scaffold(
          body: CommonTextField(
            controller: emailController,
            autofillHints: hints,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofillHints, hints);
    });

    testWidgets('AuthFormFields.email uses default email and username autofillHints', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: AuthFormFields.email(
            controller: emailController,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(
        textField.autofillHints,
        containsAll([AutofillHints.email, AutofillHints.username]),
      );
    });

    testWidgets('AuthFormFields.password uses default password autofillHints', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: AuthFormFields.password(
            controller: passwordController,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(
        textField.autofillHints,
        contains(AutofillHints.password),
      );
    });

    testWidgets('AuthFormFields.password allows custom newPassword autofillHints', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: AuthFormFields.password(
            controller: passwordController,
            autofillHints: const [AutofillHints.newPassword],
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(
        textField.autofillHints,
        contains(AutofillHints.newPassword),
      );
    });

    testWidgets('PhoneFormField provides telephoneNumber autofillHints', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: PhoneFormField(
            phoneNumberController: phoneController,
            phoneFocusNode: phoneFocusNode,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(
        textField.autofillHints,
        contains(AutofillHints.telephoneNumber),
      );
    });

    testWidgets('AutofillGroup groups email and password fields for password managers', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: AutofillGroup(
            child: Column(
              children: [
                AuthFormFields.email(controller: emailController),
                AuthFormFields.password(controller: passwordController),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(AutofillGroup), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });
  });
}
