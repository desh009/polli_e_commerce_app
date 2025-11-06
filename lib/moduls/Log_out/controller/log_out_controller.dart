// moduls/Log_out/controller/log_out_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/controller/login_controller.dart';

class LogoutController extends GetxController {
  var isLoggingOut = false.obs;
  final EpicAuthController authController = Get.find(); // ✅ Use main auth controller

  Future<void> logout() async {
    isLoggingOut.value = true;

    try {
      print('🔄 LogoutController: Starting logout process...');
      
      // ✅ Use the main auth controller for proper logout
      await authController.executeUserLogout();
      
      print('✅ LogoutController: Logout completed successfully');

    } catch (e) {
      print('❌ LogoutController: Error during logout: $e');
      Get.snackbar(
        "Logout Error", 
        "Something went wrong during logout",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoggingOut.value = false;
    }
  }
}