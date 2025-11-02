// lib/core/widgets/auth_controller.dart
import 'dart:ui';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Login_screen.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  VoidCallback? pendingAction;

 void login() {
    isLoggedIn.value = true;
    pendingAction?.call(); // pending কাজ execute হবে
    pendingAction = null;
  }


    // ✅ Login হলে pending কাজ execute হবে (যেমন Checkout এ যাওয়া)
 
  void logout() {
    isLoggedIn.value = false;
  }
    void checkAuthAndExecute(VoidCallback action) {
    if (isLoggedIn.value) {
      action(); // যদি লগইন থাকে, সরাসরি চালাও
    } else {
      pendingAction = action; // কাজ টা pending রাখো
      Get.to(() => LoginScreen()); // Login screen এ পাঠাও
    }
  }
}

