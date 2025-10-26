// lib/core/widgets/auth_controller.dart
import 'dart:ui';

import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/Login_screen/Login_screen.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  VoidCallback? pendingAction;

  void login() {
    isLoggedIn.value = true;
    pendingAction?.call(); // pending কাজ execute হবে
    pendingAction = null;
    update();
  }

  void logout() {
    isLoggedIn.value = false;
    pendingAction = null;
    update();
  }

  // ✅ Login screen এ navigate করার function
  void navigateToLogin() {
    Get.to(() => LoginScreen());
  }
}