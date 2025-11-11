// lib/core/controller/auth/forgot_password_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Forgot_password_Screen/repository/forgot_password_repostory.dart';

class ForgotPasswordController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString email = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSuccess = false.obs;

  final ForgotPasswordRepository repository = ForgotPasswordRepository();

  // Email validation function
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'দয়া করে আপনার ইমেইল এড্রেস লিখুন';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'দয়া করে সঠিক ইমেইল এড্রেস লিখুন';
    }
    return null;
  }

  // Reset password function
  Future<void> resetPassword() async {
    // Validate email first
    final validationError = validateEmail(email.value);
    if (validationError != null) {
      errorMessage.value = validationError;
      return;
    }

    errorMessage.value = '';
    isLoading.value = true;
    isSuccess.value = false;

    try {
      final response = await repository.forgotPassword(email.value);

      if (response.success) {
        isSuccess.value = true;
        
        // Show success message
        Get.snackbar(
          "সফল!",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(16),
        );

        // Navigate back after 2 seconds
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Demo reset password function
  Future<void> demoResetPassword() async {
    errorMessage.value = '';
    isLoading.value = true;
    isSuccess.value = false;

    try {
      final response = await repository.demoForgotPassword(email.value);

      if (response.success) {
        isSuccess.value = true;
        
        Get.snackbar(
          "ডেমো: সফল!",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(16),
        );

        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Error handling function
  String _handleError(dynamic error) {
    final errorString = error.toString();
    
    if (errorString.contains('Network error') || 
        errorString.contains('SocketException') ||
        errorString.contains('ClientException')) {
      return 'ইন্টারনেট কানেকশন সমস্যা। দয়া করে ইন্টারনেট চেক করুন।';
    } else if (errorString.contains('User not found')) {
      return 'এই ইমেইলে কোনো ইউজার খুঁজে পাওয়া যায়নি।';
    } else if (errorString.contains('Validation error')) {
      return 'ইমেইল ফর্মেট সঠিক নয়।';
    } else if (errorString.contains('Server error')) {
      return 'সার্ভার সমস্যা। পরে আবার চেষ্টা করুন।';
    } else if (errorString.contains('Invalid request')) {
      return 'অনুরোধটি সঠিক নয়। দয়া করে আবার চেষ্টা করুন।';
    } else {
      return 'একটি সমস্যা হয়েছে: ${error.toString()}';
    }
  }

  // Demo fill function
  void demoFill() {
    email.value = "pofehi7975@fandoe.com";
  }

  // Clear error message
  void clearError() {
    errorMessage.value = '';
  }
}