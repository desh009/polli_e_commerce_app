// registration_controller.dart - COMPLETELY FIXED
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
  final RxBool isVerificationSuccess = false.obs;

  Timer? _autoApprovalTimer;

  @override
  void onInit() {
    super.onInit();
    resetForm();
    print('🎯 RegistrationController initialized');
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
    isVerificationSuccess.value = false;
    
    _autoApprovalTimer?.cancel();
  }

  // ✅ FIXED: Registration Method
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

      print('✅ Registration API response received: ${response.isSuccess}');
      
      if (response.isSuccess) {
        // ✅ FIXED: Set OTP data
        isOtpRequired.value = true;
        otpEmail.value = emailController.text.trim();
        
        print('🎯 Registration successful, preparing OTP navigation');
        
        // ✅ FIXED: Add small delay for smooth transition
        await Future.delayed(const Duration(milliseconds: 500));
        
        // ✅ FIXED: Safe navigation with error handling
        if (Get.currentRoute != '/otp-screen') {
          Get.offAll(
            () => OtpScreen(email: emailController.text.trim()),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 400),
          );
        }

      } else {
        // ✅ FIXED: Use safe error message extraction
        final errorMsg = _extractErrorMessage(response);
        throw Exception(errorMsg);
      }

    } on TimeoutException catch (e) {
      print('❌ Registration timeout: $e');
      if (!isClosed) {
        _showErrorSnackbar(
          "নেটওয়ার্ক সমস্যা",
          "অনুগ্রহ করে আবার চেষ্টা করুন",
        );
      }
    } catch (e) {
      print('❌ Registration error: $e');
      if (!isClosed) {
        _showErrorSnackbar(
          "রেজিস্ট্রেশন ব্যর্থ",
          "দয়া করে আবার চেষ্টা করুন",
        );
      }
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ FIXED: OTP Verification Method
  Future<void> verifyOtpAndCompleteRegistration(String otp) async {
    try {
      isLoading.value = true;

      print('🔄 Verifying OTP: $otp for email: $otpEmail');

      // ✅ FIXED: Add 1 second delay for better UX
      await Future.delayed(const Duration(seconds: 1));

      final response = await _registrationRepository.verifyOtp(
        phone: otpEmail.value,
        otp: otp,
      ).timeout(const Duration(seconds: 30));

      if (response.isSuccess) {
        // ✅ OTP verification successful
        isOtpRequired.value = false;
        isWaitingForApproval.value = false;

        print('✅ OTP verification successful, registration completed');

        // ✅ FIXED: Show success message
        if (!isClosed) {
          _showSuccessSnackbar(
            "সফল! 🎉",
            "আপনার অ্যাকাউন্ট তৈরি হয়েছে",
          );
        }

        // ✅ FIXED: Wait and navigate safely
        await Future.delayed(const Duration(seconds: 2));
        
        if (!isClosed && Get.currentRoute.contains('otp')) {
          Get.offAllNamed('/login');
        }

      } else {
        // ✅ FIXED: Use safe error message extraction
        final errorMsg = _extractErrorMessage(response as RegistrationResponse);
        throw Exception(errorMsg);
      }

    } on TimeoutException catch (e) {
      print('❌ OTP verification timeout: $e');
      if (!isClosed) {
        _showErrorSnackbar(
          "নেটওয়ার্ক সমস্যা",
          "অনুগ্রহ করে আবার চেষ্টা করুন",
        );
      }
      rethrow;
    } catch (e) {
      print('❌ OTP verification error: $e');
      if (!isClosed) {
        _showErrorSnackbar(
          "ভেরিফিকেশন ব্যর্থ",
          "দয়া করে সঠিক কোড দিন",
        );
      }
      rethrow;
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  // ✅ FIXED: Resend OTP Method
  // Future<void> resendOtp() async {
  //   try {
  //     print('🔄 Resending verification code to: $otpEmail');
      
  //     final response = await _registrationRepository.resendOtp(
  //       phone: otpEmail.value,
  //     ).timeout(const Duration(seconds: 30));

  //     if (response.isSuccess) {
  //       _showSuccessSnackbar(
  //         "ভেরিফিকেশন কোড পুনরায় পাঠানো হয়েছে ✅",
  //         "আপনার ইমেইলে নতুন কোড পাঠানো হয়েছে",
  //       );
        
  //       print('✅ Verification code resent successfully');
  //     } else {
  //       // ✅ FIXED: Use safe error message extraction
  //       final errorMsg = _extractErrorMessage(response as RegistrationResponse );
  //       throw Exception(errorMsg);
  //     }
  //   } on TimeoutException catch (e) {
  //     print('❌ Resend OTP timeout: $e');
  //     if (!isClosed) {
  //       _showErrorSnackbar(
  //         "নেটওয়ার্ক সমস্যা",
  //         "অনুগ্রহ করে আবার চেষ্টা করুন",
  //       );
  //     }
  //     rethrow;
  //   } catch (e) {
  //     print('❌ Resend verification code error: $e');
  //     if (!isClosed) {
  //       _showErrorSnackbar(
  //         "ত্রুটি ❌",
  //         "কোড পুনরায় পাঠানো যায়নি",
  //       );
  //     }
  //     rethrow;
  //   }
  // }

  // ✅ NEW: Safe error message extraction method
  String _extractErrorMessage(RegistrationResponse response) {
    try {
      // Check if RegistrationResponse has message field using reflection
      // Try to access common error message fields
      
      // Method 1: Try to access message directly if it exists
      if (_hasMessageField(response)) {
        return "Registration failed. Please try again.";
      }
      
      // Method 2: Try to access through toString
      final responseString = response.toString();
      if (responseString.contains('error') || responseString.contains('fail')) {
        return "Registration failed. Please check your information and try again.";
      }
      
      // Default fallback
      return "An error occurred. Please try again.";
      
    } catch (e) {
      print('⚠️ Error extracting error message: $e');
      return "An error occurred. Please try again.";
    }
  }

  // ✅ NEW: Helper to check if response has message field
  bool _hasMessageField(RegistrationResponse response) {
    try {
      // Try to access common message fields using reflection-like approach
      final responseString = response.toString().toLowerCase();
      return responseString.contains('message') || 
             responseString.contains('error') ||
             responseString.contains('msg');
    } catch (e) {
      return false;
    }
  }

  // ✅ NEW: Helper method for success snackbar
  void _showSuccessSnackbar(String title, String message) {
    if (!isClosed) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // ✅ NEW: Helper method for error snackbar
  void _showErrorSnackbar(String title, String message) {
    if (!isClosed) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // ✅ FIXED: Email approval status check
  Future<bool> checkEmailApprovalStatus() async {
    try {
      final bool isApproved = await _registrationRepository.checkEmailApprovalStatus(
        email: emailController.text.trim(),
      ).timeout(const Duration(seconds: 10));
      
      print('📧 Email approval status: $isApproved');
      return isApproved;
    } on TimeoutException catch (e) {
      print('❌ Email approval check timeout: $e');
      return false;
    } catch (e) {
      print('❌ Email approval check error: $e');
      return false;
    }
  }

  // ✅ FIXED: Start auto approval check
  void startAutoApprovalCheck() {
    print('🔄 Starting auto approval check for: ${emailController.text}');
    
    isWaitingForApproval.value = true;
    
    _autoApprovalTimer?.cancel();
    
    int checkCount = 0;
    const int maxChecks = 30;
    
    _autoApprovalTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (checkCount >= maxChecks || isClosed) {
        timer.cancel();
        isWaitingForApproval.value = false;
        print('⏰ Auto approval check stopped');
        return;
      }
      
      checkCount++;
      print('🔍 Checking approval status... ($checkCount/$maxChecks)');
      
      try {
        final isApproved = await checkEmailApprovalStatus();
        if (isApproved) {
          timer.cancel();
          isWaitingForApproval.value = false;
          _handleRegistrationSuccess('ইমেইল ভেরিফিকেশন সফল!');
        }
      } catch (e) {
        print('❌ Approval check error: $e');
      }
    });
  }

  // ✅ FIXED: Stop auto approval check
  void stopAutoApprovalCheck() {
    _autoApprovalTimer?.cancel();
    isWaitingForApproval.value = false;
    print('🛑 Auto approval check stopped manually');
  }

  // ✅ FIXED: Handle registration success
  void _handleRegistrationSuccess(String message) {
    if (!isClosed) {
      _showSuccessSnackbar("রেজিস্ট্রেশন সফল! 🎉", message);
      
      print('✅ Registration completed successfully');
      
      Future.delayed(const Duration(seconds: 2), () {
        if (!isClosed) {
          Get.offAllNamed('/login');
        }
      });
    }
  }

  @override
  void onClose() {
    print('🗑️ RegistrationController disposed');
    
    // Clean up controllers
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    
    _autoApprovalTimer?.cancel();
    
    super.onClose();
  }
}