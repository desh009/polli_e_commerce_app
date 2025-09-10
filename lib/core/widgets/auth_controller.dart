import 'dart:ui';

import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  VoidCallback? pendingAction;

  void login() {
    isLoggedIn.value = true;
    pendingAction?.call(); // pending কাজ execute হবে
    pendingAction = null;
  }

  void logout() {
    isLoggedIn.value = false;
  }
}
