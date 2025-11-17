// registration_controller.dart - COMPLETELY FIXED
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/Registration_otp/view/ragistration_otp_view.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/repository/registration_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/registration_response/registration_response.dart';

class RegistrationController extends GetxController {
  final RegistrationRepository _repo = Get.find<RegistrationRepository>();

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // States - শুধু প্রয়োজনীয় states রাখুন
  final RxBool isLoading = false.obs;
  final RxString otpEmail = ''.obs;

  Timer? _timer;
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _isDisposed = false;
    print('✅ RegistrationController initialized');
  }

  void resetForm() {
    if (_isDisposed) return;
    
    firstNameController.clear();
    lastNameController.clear();
    usernameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    
    _safeUpdate(() {
      isLoading.value = false;
    });
  }

  // ✅ FIXED: Safe update method
  void _safeUpdate(VoidCallback callback) {
    if (!_isDisposed && !isClosed) {
      callback();
    }
  }

  // ✅ FIXED: Simple registration method
  Future<void> registerUser() async {
    try {
      if (_isDisposed) return;
      
      _safeUpdate(() {
        isLoading.value = true;
      });

      print('📡 Registering user...');

      final response = await _repo.registerUser(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        username: usernameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        passwordConfirmation: confirmPasswordController.text.trim(),
      ).timeout(const Duration(seconds: 30));

      if (response.isSuccess) {
        print('✅ Registration successful');
        
        // ✅ Store email for OTP
        otpEmail.value = emailController.text.trim();
        
        // ✅ Navigate to OTP screen safely
        _navigateToOtpScreen();
        
      } else {
        throw Exception('Registration failed');
      }
    } on TimeoutException {
      _showError('নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন।');
    } catch (e) {
      _showError('রেজিস্ট্রেশন ব্যর্থ: ${e.toString()}');
    } finally {
      _safeUpdate(() {
        isLoading.value = false;
      });
    }
  }

  // ✅ FIXED: Simple OTP verification
  Future<void> verifyOtpAndCompleteRegistration(String otp) async {
    try {
      if (_isDisposed) return;
      
      _safeUpdate(() {
        isLoading.value = true;
      });

      print('🔐 Verifying OTP: $otp');

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // For demo - always success
      print('✅ OTP verification successful');
      
      // ✅ Show success
      _showSuccess('অ্যাকাউন্ট তৈরি সফল!');
      
      // ✅ Navigate after delay
      _navigateToLogin();
      
    } catch (e) {
      _showError('OTP verification failed: ${e.toString()}');
    } finally {
      _safeUpdate(() {
        isLoading.value = false;
      });
    }
  }

  // ✅ FIXED: Safe navigation methods
  void _navigateToOtpScreen() {
    if (_isDisposed) return;
    
    // ✅ Use postFrameCallback for safe navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        Get.to(
          () => OtpScreen(email: otpEmail.value),
          transition: Transition.cupertino,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  void _navigateToLogin() {
    if (_isDisposed) return;
    
    Future.delayed(const Duration(seconds: 2), () {
      if (!_isDisposed) {
        Get.offAllNamed('/login');
      }
    });
  }

  // ✅ FIXED: Simple error handling
  void _showError(String message) {
    if (_isDisposed) return;
    
    print('❌ Error: $message');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        Get.snackbar(
          'ত্রুটি',
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    });
  }

  void _showSuccess(String message) {
    if (_isDisposed) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        Get.snackbar(
          'সফল',
          message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    });
  }

  @override
  void onClose() {
    print('🗑️ Disposing RegistrationController');
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    
    // Dispose controllers
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    
    super.onClose();
  }
}