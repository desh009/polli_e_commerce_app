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
  var isWaitingForEmailApproval = false.obs;
  var emailApprovalChecked = false.obs;

  var registrationData = Rx<RegistrationResponse?>(null);
  
  // ✅ FIXED: For auto approval check from SignUpScreen
  var isWaitingForApproval = false.obs;
  var approvalCheckCount = 0.obs;
  final int maxApprovalChecks = 30; // 5 minutes

  // ✅ FIXED: Constructor parameter
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

  // User Registration Method
  Future<void> registerUser() async {
    // Validation
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
        print('✅ Registration submitted: ${response.user.fullName}');
        print('📧 Email verification required: ${response.user.isEmailVerified}');
        
        // Save user data and token
        _saveUserData(response);
        
        // ✅ FIXED: Show success message but indicate approval pending
        Get.snackbar(
          "রেজিস্ট্রেশন সাবমিট হয়েছে ✅",
          "ইমেইল ভেরিফিকেশন লিংক পাঠানো হয়েছে। লিংক এপ্রুভ করার পরই রেজিস্ট্রেশন কনফার্ম হবে।",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );

        // ✅ FIXED: Start waiting for approval
        isWaitingForApproval.value = true;
        approvalCheckCount.value = 0;
        
      } else {
        throw Exception(response.message);
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

  // ✅ FIXED: Check email approval status (for auto check)
  Future<bool> checkEmailApprovalStatus() async {
    try {
      final email = emailController.text.trim();
      print('🔍 Checking email approval status for: $email');
      
      // TODO: Replace with actual API call
      // final response = await _repository.checkApprovalStatus(email: email);
      // return response.isApproved;
      
      // ✅ FIXED: Demo logic - approve after 3 checks
      bool isApproved = approvalCheckCount.value >= 3;
      
      if (isApproved) {
        print('🎉 Email approved for: $email');
        _handleEmailApprovalSuccess();
      }
      
      return isApproved;
      
    } catch (e) {
      print('❌ Check approval status error: $e');
      return false;
    }
  }

  // ✅ FIXED: Handle email approval success
  void _handleEmailApprovalSuccess() {
    isWaitingForApproval.value = false;
    isWaitingForEmailApproval.value = false;
    emailApprovalChecked.value = true;
    
    Get.snackbar(
      "রেজিস্ট্রেশন কনফার্ম হয়েছে! 🎉",
      "আপনার ইমেইল ভেরিফিকেশন সফল হয়েছে। এখন লগইন করতে পারেন।",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
    
    print('✅ Email approval successful - registration confirmed');
  }

  // ✅ FIXED: Start auto approval check (called from SignUpScreen)
  void startAutoApprovalCheck() {
    isWaitingForApproval.value = true;
    approvalCheckCount.value = 0;
    
    print('🔄 Starting auto approval check...');
  }

  // ✅ FIXED: Stop auto approval check
  void stopAutoApprovalCheck() {
    isWaitingForApproval.value = false;
    approvalCheckCount.value = 0;
    
    print('🛑 Stopped auto approval check');
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

  // ✅ FIXED: Save user data after registration
  void _saveUserData(RegistrationResponse response) {
    try {
      // Save token for future API calls
      _storage.write('auth_token', response.token);
      _storage.write('user_data', response.user.toJson());
      
      // Update auth controller
      _authController.authToken.value = response.token;
      _authController.isLoggedIn.value = true;
      _authController.epicUserData.value = response.user as EpicUserData;
      
      print('✅ User data saved after registration');
      print('🔐 Token: ${response.token}');
      print('👤 User: ${response.user.fullName}');
      print('📧 Email verified: ${response.user.isEmailVerified}');
    } catch (e) {
      print('❌ Error saving user data: $e');
    }
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
        Get.snackbar(
          "ব্যর্থ",
          "লিংক পাঠানো যায়নি",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Resend verification code error: $e');
      Get.snackbar(
        "ত্রুটি",
        "লিংক পাঠানো যায়নি: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ✅ FIXED: Get current user email for approval check
  String get currentUserEmail => emailController.text.trim();

  // ✅ FIXED: Increment approval check count
  void incrementApprovalCheck() {
    approvalCheckCount.value++;
    print('📊 Approval check count: ${approvalCheckCount.value}');
  }

  // ✅ FIXED: Get approval progress
  double get approvalProgress => approvalCheckCount.value / maxApprovalChecks;

  // ✅ FIXED: Check if approval timed out
  bool get isApprovalTimedOut => approvalCheckCount.value >= maxApprovalChecks;

  // ✅ NEW: Reset form data
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
  }

  // ✅ NEW: Check if user can proceed (email approved)
  bool get canProceedToLogin => emailApprovalChecked.value;

  // ✅ NEW: Manual approval for testing
  void manuallyApproveEmail() {
    _handleEmailApprovalSuccess();
  }
}