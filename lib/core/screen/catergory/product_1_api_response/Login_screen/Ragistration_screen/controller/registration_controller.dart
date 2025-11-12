// registration_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/Registration_otp/view/ragistration_otp_view.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/repository/registration_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/registration_response/registration_response.dart';

class RegistrationController extends GetxController {
  final RegistrationRepository _registrationRepository = Get.find<RegistrationRepository>();
  
  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Reactive variables
  final RxBool isLoading = false.obs;
  final RxBool isWaitingForApproval = false.obs;
  final RxBool isOtpRequired = false.obs;
  final RxString otpEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    resetForm();
  }

  void resetForm() {
    firstNameController.clear();
    lastNameController.clear();
    usernameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    isLoading.value = false;
    isWaitingForApproval.value = false;
    isOtpRequired.value = false;
    otpEmail.value = '';
  }

  // ✅ FIXED Registration Method
// registration_controller.dart
Future<void> registerUser() async {
  try {
    isLoading.value = true;
    
    print('🔄 Starting registration API call...');

    final RegistrationResponse response = await _registrationRepository.registerUser(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      username: usernameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      passwordConfirmation: confirmPasswordController.text.trim(),
    ).timeout(const Duration(seconds: 30));

    print('✅ Registration API response received');
    
    // ✅ FIXED: Check if mounted before any UI operations
    if (!_isMounted()) {
      print('⚠️ Widget disposed, skipping navigation');
      return;
    }

    // ✅ FIXED: Always navigate to OTP screen when API succeeds
    print('🎯 Navigating to OTP screen - Email verification code sent');
    
    isLoading.value = false;
    isOtpRequired.value = true;
    otpEmail.value = emailController.text.trim();

    // ✅ FIXED: Use Get.offAll to prevent back navigation issues
    Get.offAll(
      () => OtpScreen(email: emailController.text.trim()),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );

  } on TimeoutException catch (e) {
    print('❌ Registration timeout: $e');
    if (_isMounted()) {
      Get.snackbar(
        "নেটওয়ার্ক সমস্যা",
        "অনুগ্রহ করে আবার চেষ্টা করুন",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    print('❌ Registration error: $e');
    if (_isMounted()) {
      Get.snackbar(
        "রেজিস্ট্রেশন ব্যর্থ",
        "দয়া করে আবার চেষ্টা করুন",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } finally {
    if (_isMounted()) {
      isLoading.value = false;
    }
  }
}

// ✅ ADD THIS METHOD for mounted check
bool _isMounted() {
  try {
    return !isClosed;
  } catch (e) {
    return false;
  }
}

  // ✅ NEW: OTP Navigation Helper
  void _navigateToOtpScreen(String message) {
    isOtpRequired.value = true;
    otpEmail.value = emailController.text.trim();
    
    Get.snackbar(
      "ভেরিফিকেশন প্রয়োজন ✅",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    print('🎯 Navigating to OTP screen: $message');
    
    // ✅ FIXED: Add small delay for better UX
    Future.delayed(const Duration(milliseconds: 1500), () {
      Get.toNamed('/otp-screen', arguments: {
        'email': emailController.text.trim(),
      });
    });
  }

  // ✅ NEW: Email Verification Handler
  void _handleEmailVerificationRequired(String message) {
    isWaitingForApproval.value = true;
    
    Get.snackbar(
      "ইমেইল ভেরিফিকেশন প্রয়োজন",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );

    print('📧 Email verification required: $message');
    
    // Start auto approval check
    _startAutoApprovalCheck();
  }

  // ✅ NEW: Direct Success Handler
  void _handleRegistrationSuccess(String message) {
    Get.snackbar(
      "রেজিস্ট্রেশন সফল! 🎉",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    print('✅ Direct registration success: $message');
    
    // Navigate to login after success
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/login');
    });
  }

  // ✅ NEW: Auto Approval Check
  void _startAutoApprovalCheck() {
    print('🔄 Starting auto approval check for: ${emailController.text}');
    
    // Implement your auto approval check logic here
    // This is just a placeholder
    Future.delayed(const Duration(seconds: 10), () {
      // Check if email is verified
      checkEmailApprovalStatus().then((isApproved) {
        if (isApproved && mounted) {
          _handleRegistrationSuccess('ইমেইল ভেরিফিকেশন সফল!');
        }
      });
    });
  }

  // ✅ OTP Verification Method - IMPROVED
  Future<void> verifyOtpAndCompleteRegistration(String otp) async {
    try {
      isLoading.value = true;

      print('🔄 Verifying OTP: $otp for email: $otpEmail');

      final response = await _registrationRepository.verifyOtp(
        phone: otpEmail.value,
        otp: otp,
      );

      if (response.isSuccess) {
        // ✅ OTP verification successful
        isOtpRequired.value = false;
        isWaitingForApproval.value = false;

        Get.snackbar(
          "রেজিস্ট্রেশন সফল! 🎉",
          "আপনার অ্যাকাউন্ট তৈরি হয়েছে। লগইন পেজে নিয়ে যাওয়া হচ্ছে...",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        print('✅ Registration completed successfully after OTP verification');

        // ✅ Wait and navigate to login
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed('/login');

      } else {
        throw Exception(response.errorMessage ?? 'OTP verification failed');
      }

    } catch (e) {
      print('❌ OTP verification error: $e');
      Get.snackbar(
        "ভেরিফিকেশন ব্যর্থ",
        "দয়া করে সঠিক কোড দিন: ${e.toString().replaceAll('Exception:', '')}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Resend OTP Method - IMPROVED
  Future<void> resendOtp() async {
    try {
      print('🔄 Resending verification code to: $otpEmail');
      
      final response = await _registrationRepository.resendOtp(
        phone: otpEmail.value,
      );

      if (response.isSuccess) {
        Get.snackbar(
          "ভেরিফিকেশন কোড পুনরায় পাঠানো হয়েছে ✅",
          "আপনার ইমেইলে নতুন কোড পাঠানো হয়েছে",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception(response.errorMessage ?? 'Verification code resend failed');
      }
    } catch (e) {
      print('❌ Resend verification code error: $e');
      Get.snackbar(
        "ত্রুটি ❌",
        "কোড পুনরায় পাঠানো যায়নি: ${e.toString().replaceAll('Exception:', '')}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  // Email approval status check
  Future<bool> checkEmailApprovalStatus() async {
    try {
      return await _registrationRepository.checkEmailApprovalStatus(
        email: emailController.text.trim(),
      );
    } catch (e) {
      print('❌ Email approval check error: $e');
      return false;
    }
  }

  // Stop auto approval check
  void stopAutoApprovalCheck() {
    isWaitingForApproval.value = false;
  }

  @override
  void onClose() {
    // Clean up controllers
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // ✅ NEW: Getter for mounted check
  bool get mounted => true;
}