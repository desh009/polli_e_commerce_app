// moduls/Log_out/controller/log_out_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/controller/login_controller.dart';
import 'package:polli_e_commerce_app/core/widgets/auth_controller.dart';

class LogoutController extends GetxController {
  var isLoggingOut = false.obs;
  final EpicAuthController authController = Get.find();
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    print('✅ LogoutController initialized');
  }

  Future<void> logout() async {
    if (isLoggingOut.value) {
      print('⚠️ Logout already in progress, skipping...');
      return;
    }

    isLoggingOut.value = true;

    try {
      print('🔄 ========== LOGOUT CONTROLLER STARTED ==========');
      print('📍 Current route: ${Get.currentRoute}');
      print('🔐 Auth status before logout: ${authController.isLoggedIn.value}');

      // ✅ Use the main auth controller for proper logout
      await authController.executeUserLogout();
      
      print('✅ LogoutController: Main logout completed');
      
      // ✅ Additional safety: Clear any remaining local data
      await _clearRemainingData();
      
      print('✅ LogoutController: All cleanup completed');

    } catch (e, stackTrace) {
      print('❌ LogoutController: Error during logout: $e');
      print('📋 Stack trace: $stackTrace');
      
      // ✅ Emergency cleanup even if error occurs
      await _emergencyLogout();
      
      Get.snackbar(
        "লগআউট সমস্যা", 
        "তথ্য ক্লিয়ার করা হয়েছে,但有技术问题",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoggingOut.value = false;
      print('🔄 LogoutController: Process finished');
    }
  }

  // ✅ Clear any remaining local data
  Future<void> _clearRemainingData() async {
    try {
      print('🧹 Clearing remaining local data...');
      
      // Clear additional storage items that might remain
      await _storage.remove('cart_data');
      await _storage.remove('recent_searches');
      await _storage.remove('user_preferences');
      await _storage.remove('last_login');
      
      // Clear GetX dependencies that might hold state
      _clearGetXDependencies();
      
      print('✅ Remaining data cleared successfully');
    } catch (e) {
      print('❌ Error clearing remaining data: $e');
    }
  }

  // ✅ Clear GetX dependencies
  void _clearGetXDependencies() {
    try {
      print('🗑️ Clearing GetX dependencies...');
      
      // Note: Be careful with this - only clear non-essential controllers
      // Essential controllers like AuthController should remain
      
      // Example: if you have cart controller
      // if (Get.isRegistered<CartController>()) {
      //   Get.delete<CartController>(force: true);
      // }
      
      print('✅ GetX dependencies cleared');
    } catch (e) {
      print('❌ Error clearing GetX dependencies: $e');
    }
  }

  // ✅ Emergency logout when everything else fails
  Future<void> _emergencyLogout() async {
    try {
      print('🚨 EMERGENCY LOGOUT ACTIVATED');
      
      // Force clear all storage
      await _storage.erase();
      
      // Force reset auth controller state
      authController.isLoggedIn.value = false;
      authController.authToken.value = '';
      authController.epicUserData.value = null;
      
      // Force navigation to home
      if (Get.currentRoute != '/') {
        Get.offAllNamed('/');
      }
      
      print('✅ Emergency logout completed');
    } catch (e) {
      print('❌ CRITICAL: Emergency logout also failed: $e');
      // Last resort - restart app
      _restartApp();
    }
  }

  // ✅ Last resort - show restart dialog
  void _restartApp() {
    print('🔄 Showing restart dialog...');
    
    Get.dialog(
      AlertDialog(
        title: Text('অ্যাপ রিস্টার্ট প্রয়োজন'),
        content: Text('দয়া করে অ্যাপ বন্ধ করে আবার খুলুন।'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('ঠিক আছে'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // ✅ Quick logout without confirmation (for testing)
  Future<void> quickLogout() async {
    print('⚡ Quick logout called');
    
    // Direct navigation first
    Get.offAllNamed('/');
    
    // Then clear data
    await authController.executeUserLogout();
  }

  // ✅ Check if user can logout (for UI state)
  bool get canLogout => !isLoggingOut.value;

  // ✅ Get logout progress message
  String get logoutStatus {
    if (isLoggingOut.value) {
      return "লগআউট করা হচ্ছে...";
    }
    return "লগআউট";
  }

  @override
  void onClose() {
    print('🛑 LogoutController disposed');
    super.onClose();
  }
}