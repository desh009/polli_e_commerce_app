// lib/core/screen/catergory/product_1_api_response/Login_screen/Registration_screen/controller/registration_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/registration_response/registration_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/repository/registration_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/controller/login_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/login_response/login_response.dart';

class RegistrationController extends GetxController {
  final RegistrationRepository _repository;
  final EpicAuthController _authController = Get.find();
  final GetStorage _storage = GetStorage();

  // Text Editing Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Observable variables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isWaitingForApproval = false.obs;
  var emailApprovalChecked = false.obs;

  var registrationData = Rx<RegistrationResponse?>(null);
  
  var approvalCheckCount = 0.obs;
  final int maxApprovalChecks = 30;

  RegistrationController(this._repository);

  @override
  void onInit() {
    super.onInit();
    print('✅ RegistrationController initialized');
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // ✅ FIXED: User Registration Method - Check email verification status
  Future<void> registerUser() async {
    if (!_validateForm()) {
      return;
    }

    try {
      isLoading.value = true;
      print('🔄 Starting user registration...');

      final response = await _repository.registerUser(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        username: usernameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        passwordConfirmation: confirmPasswordController.text.trim(),
      );

      registrationData.value = response;

      if (response.isSuccess) {
        print('✅ Registration API response received');
        print('📧 Email verification status: ${response.user.isEmailVerified}');
        
        // ✅ FIXED: Check if email is verified before proceeding
        if (response.user.isEmailVerified == true) {
          print('🎉 Email already verified - completing registration');
          _handleSuccessfulRegistration(response);
        } else {
          print('⏳ Email verification required - waiting for approval');
          _handlePendingVerification(response);
        }
      } else {
        throw Exception(response.message ?? 'Registration failed');
      }

    } catch (e) {
      print('❌ Registration error: $e');
      Get.snackbar(
        "রেজিস্ট্রেশন ব্যর্থ",
        e.toString().replaceAll('Exception:', '').trim(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ FIXED: Handle successful registration (email already verified)
  void _handleSuccessfulRegistration(RegistrationResponse response) {
    // Save user data and token
    _saveUserData(response);
    
    // Set approval status to false since email is already verified
    isWaitingForApproval.value = false;
    emailApprovalChecked.value = true;
    
    print('✅ Registration completed successfully - user can login immediately');
  }

  // ✅ FIXED: Handle pending verification (email not verified)
  void _handlePendingVerification(RegistrationResponse response) {
    // ❌ DON'T save user data yet - wait for email verification
    // _saveUserData(response); // REMOVED
    
    // ✅ ONLY set waiting status
    isWaitingForApproval.value = true;
    emailApprovalChecked.value = false;
    approvalCheckCount.value = 0;
    
    print('⏳ Registration pending - waiting for email verification');
  }

  // ✅ FIXED: Check email approval status
  Future<bool> checkEmailApprovalStatus() async {
    try {
      final email = emailController.text.trim();
      print('🔍 Checking email approval status for: $email');
      
      // TODO: Replace with actual API call to check verification status
      // final isApproved = await _repository.checkEmailApprovalStatus(email: email);
      
      // ✅ FIXED: Demo logic - simulate API call delay and check
      await Future.delayed(const Duration(seconds: 2));
      
      // In real scenario, this would come from API
      bool isApproved = approvalCheckCount.value >= 2; // Approve after 2 checks for demo
      
      if (isApproved) {
        print('🎉 Email approved for: $email');
        _handleEmailApprovalSuccess();
      } else {
        print('⏳ Email still pending approval for: $email');
      }
      
      return isApproved;
      
    } catch (e) {
      print('❌ Check approval status error: $e');
      return false;
    }
  }

  // ✅ FIXED: Handle email approval success
  void _handleEmailApprovalSuccess() {
    // Now save user data since email is verified
    if (registrationData.value != null) {
      _saveUserData(registrationData.value!);
    }
    
    isWaitingForApproval.value = false;
    emailApprovalChecked.value = true;
    
    print('✅ Email approval successful - registration confirmed and user data saved');
  }

  // ✅ FIXED: Save user data ONLY after email verification
  void _saveUserData(RegistrationResponse response) {
    try {
      // Save token for future API calls
      _storage.write('auth_token', response.token);
      _storage.write('user_data', response.user.toJson());
      
      // Update auth controller
      _authController.authToken.value = response.token;
      _authController.isLoggedIn.value = true;
      _authController.epicUserData.value = response.user as EpicUserData;
      
      print('✅ User data saved after email verification');
      print('🔐 Token: ${response.token}');
      print('👤 User: ${response.user.fullName}');
      print('📧 Email verified: ${response.user.isEmailVerified}');
    } catch (e) {
      print('❌ Error saving user data: $e');
    }
  }

  // ✅ FIXED: Form Validation
  bool _validateForm() {
    if (firstNameController.text.isEmpty) {
      Get.snackbar("ত্রুটি", "দয়া করে নাম লিখুন", backgroundColor: Colors.red);
      return false;
    }
    if (lastNameController.text.isEmpty) {
      Get.snackbar("ত্রুটি", "দয়া করে উপাধি লিখুন", backgroundColor: Colors.red);
      return false;
    }
    if (usernameController.text.isEmpty) {
      Get.snackbar("ত্রুটি", "দয়া করে ইউজারনেম লিখুন", backgroundColor: Colors.red);
      return false;
    }
    if (phoneController.text.isEmpty) {
      Get.snackbar("ত্রুটি", "দয়া করে ফোন নম্বর লিখুন", backgroundColor: Colors.red);
      return false;
    }
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      Get.snackbar("ত্রুটি", "দয়া করে সঠিক ইমেইল লিখুন", backgroundColor: Colors.red);
      return false;
    }
    if (passwordController.text.length < 6) {
      Get.snackbar("ত্রুটি", "পাসওয়ার্ড অন্তত ৬ ক্যারেক্টার হতে হবে", backgroundColor: Colors.red);
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("ত্রুটি", "পাসওয়ার্ড মিলেনি", backgroundColor: Colors.red);
      return false;
    }
    return true;
  }

  // Start auto approval check
  void startAutoApprovalCheck() {
    isWaitingForApproval.value = true;
    approvalCheckCount.value = 0;
    print('🔄 Starting auto approval check...');
  }

  // Stop auto approval check
  void stopAutoApprovalCheck() {
    isWaitingForApproval.value = false;
    approvalCheckCount.value = 0;
    print('🛑 Stopped auto approval check');
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Resend verification code
  Future<void> resendVerificationCode() async {
    try {
      final email = emailController.text.trim();
      if (email.isEmpty) {
        Get.snackbar("ত্রুটি", "ইমেইল এড্রেস পাওয়া যায়নি", backgroundColor: Colors.red);
        return;
      }

      print('📧 Resending verification code to: $email');
      
      final success = await _repository.resendVerificationCode(email: email);
      
      if (success) {
        Get.snackbar(
          "লিংক পাঠানো হয়েছে ✅",
          "ভেরিফিকেশন লিংকটি আবার আপনার ইমেইলে পাঠানো হয়েছে",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar("ব্যর্থ", "লিংক পাঠানো যায়নি", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('❌ Resend verification code error: $e');
      Get.snackbar("ত্রুটি", "লিংক পাঠানো যায়নি: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Get current user email for approval check
  String get currentUserEmail => emailController.text.trim();

  // Increment approval check count
  void incrementApprovalCheck() {
    approvalCheckCount.value++;
    print('📊 Approval check count: ${approvalCheckCount.value}');
  }

  // Get approval progress
  double get approvalProgress => approvalCheckCount.value / maxApprovalChecks;

  // Check if approval timed out
  bool get isApprovalTimedOut => approvalCheckCount.value >= maxApprovalChecks;

  // Reset form data
  void resetForm() {
    firstNameController.clear();
    lastNameController.clear();
    usernameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    registrationData.value = null;
    isWaitingForApproval.value = false;
    approvalCheckCount.value = 0;
    emailApprovalChecked.value = false;
  }

  // Check if user can proceed (email approved)
  bool get canProceedToLogin => emailApprovalChecked.value;

  // Manual approval for testing
  void manuallyApproveEmail() {
    if (registrationData.value != null) {
      _handleEmailApprovalSuccess();
    } else {
      // For demo purposes, create a mock response
      Get.snackbar("ডেমো অ্যাপ্রুভ", "ম্যানুয়ালি ইমেইল অ্যাপ্রুভ করা হয়েছে", backgroundColor: Colors.green);
      emailApprovalChecked.value = true;
      isWaitingForApproval.value = false;
    }
  }
}