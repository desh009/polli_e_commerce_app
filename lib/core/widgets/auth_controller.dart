// lib/core/widgets/auth_controller.dart
import 'dart:ui';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/view/Login_screen.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  VoidCallback? pendingAction;
  void onLoginSuccess() {
    print('🎯 Login successful, checking pending actions...');
    
    // ✅ Execute pending action if exists (BUY NOW)
    if (pendingAction != null) {
      print('🚀 Executing pending buy now action');
      
      final savedAction = pendingAction;
      pendingAction = null; // Clear immediately
      
      // Small delay to ensure navigation completes
      Future.delayed(Duration(milliseconds: 500), () {
        print('🛒 Executing saved buy now action');
        savedAction!();
      });
    } else {
      print('💡 No pending action after login');
      // Regular login flow - navigate to home or stay
    }
  }
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

