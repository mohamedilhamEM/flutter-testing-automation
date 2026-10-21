import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:testingapp/auth/auth.dart';

class MoreController extends ChangeNotifier {
  MoreController();

  final AuthService _authService = GetIt.instance<AuthService>();

  Future<void> logout(BuildContext context) async {
    await _authService.logout();
  }
}
