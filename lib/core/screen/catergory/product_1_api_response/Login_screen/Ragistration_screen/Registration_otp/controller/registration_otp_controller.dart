import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/Registration_otp/registration_otp_response/registration_otp_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/Registration_otp/repository/registration_otp_repo.dart';

class UserZxController extends GetxController {
  final UserZxRepository _userZxRepository = Get.find<UserZxRepository>();

  // Reactive variables
  final Rx<UserModelZX?> userModelZx = Rx<UserModelZX?>(null);
  final Rx<Userwer?> currentUser = Rx<Userwer?>(null);
  final RxString authToken = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool isVerificationSuccess = false.obs; // ✅ ADDED: For OTP success tracking
  final RxBool isOtpSent = false.obs; // ✅ ADDED: For OTP sent status

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Check if token exists in local storage
      // final token = await _getStoredToken();
      // if (token != null && token.isNotEmpty) {
      //   authToken.value = token;
      //   isLoggedIn.value = true;
      //   await loadUserProfile();
      // }
    } catch (e) {
      print('Error checking auth status: $e');
    }
  }

  // ✅ FIXED: Send OTP to Email
  Future<void> sendEmailOtp(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      isOtpSent.value = false;

      print('📧 Sending OTP to email: $email');

      final response = await _userZxRepository.sendEmailOtp(email: email);

      if (response.isSuccess) {
        isOtpSent.value = true;
        print('✅ OTP sent successfully to: $email');
        
        Get.snackbar(
          'সফল!',
          'OTP আপনার ইমেইলে পাঠানো হয়েছে',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        errorMessage.value = response.errorMessage ?? 'OTP পাঠানো যায়নি';
        Get.snackbar(
          'ত্রুটি!',
          response.errorMessage ?? 'OTP পাঠানো যায়নি',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'ত্রুটি!',
        'Network error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ FIXED: Email OTP Verification
  Future<void> verifyEmailOtp(String email, String otp) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      isVerificationSuccess.value = false;

      print('🔐 Verifying Email OTP: $otp for email: $email');

      final response = await _userZxRepository.verifyEmailOtp(
        email: email, 
        otp: otp
      );
      
      if (response.isSuccess) {
        if (response.responseData != null) {
          final userModel = UserModelZX.fromJson(response.responseData!);
          userModelZx.value = userModel;
          currentUser.value = userModel.user;
          authToken.value = userModel.token;
          isLoggedIn.value = true;
          isVerificationSuccess.value = true; // ✅ Set success to true

          await _saveToken(userModel.token);
          await _saveUserData(userModel.user);

          print('✅ Email OTP Verification Successful');
          
          Get.snackbar(
            'সফল!',
            userModel.message.isNotEmpty ? userModel.message : 'ইমেইল ভেরিফিকেশন সফল হয়েছে',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

        } else {
          errorMessage.value = 'Invalid response from server';
          isVerificationSuccess.value = false;
          Get.snackbar(
            'ত্রুটি!',
            'Invalid response from server',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = response.errorMessage ?? 'OTP verification failed';
        isVerificationSuccess.value = false;
        Get.snackbar(
          'ত্রুটি!',
          response.errorMessage ?? 'OTP verification failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      isVerificationSuccess.value = false;
      Get.snackbar(
        'ত্রুটি!',
        'Network error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Phone OTP Verification (existing - keep for phone verification)
  Future<void> verifyOtp(String phone, String otp) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _userZxRepository.verifyOtp(phone: phone, otp: otp);
      
      if (response.isSuccess) {
        if (response.responseData != null) {
          final userModel = UserModelZX.fromJson(response.responseData!);
          userModelZx.value = userModel;
          currentUser.value = userModel.user;
          authToken.value = userModel.token;
          isLoggedIn.value = true;

          await _saveToken(userModel.token);
          await _saveUserData(userModel.user);

          Get.snackbar(
            'সফল!',
            userModel.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          Get.offAllNamed('/home');
        } else {
          errorMessage.value = 'Invalid response from server';
          Get.snackbar(
            'ত্রুটি!',
            'Invalid response from server',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = response.errorMessage ?? 'OTP verification failed';
        Get.snackbar(
          'ত্রুটি!',
          response.errorMessage ?? 'OTP verification failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'ত্রুটি!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // User Registration
  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _userZxRepository.registerUser(
        firstName: firstName,
        lastName: lastName,
        username: username,
        phone: phone,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      if (response.isSuccess) {
        if (response.responseData != null) {
          final userModel = UserModelZX.fromJson(response.responseData!);
          userModelZx.value = userModel;
          currentUser.value = userModel.user;
          authToken.value = userModel.token;
          isLoggedIn.value = true;

          await _saveToken(userModel.token);
          await _saveUserData(userModel.user);

          Get.snackbar(
            'সফল!',
            userModel.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          Get.offAllNamed('/home');
        } else {
          errorMessage.value = 'Invalid response from server';
          Get.snackbar(
            'ত্রুটি!',
            'Invalid response from server',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = response.errorMessage ?? 'Registration failed';
        Get.snackbar(
          'ত্রুটি!',
          response.errorMessage ?? 'Registration failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'ত্রুটি!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // User Login
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _userZxRepository.login(email: email, password: password);

      if (response.isSuccess) {
        if (response.responseData != null) {
          final userModel = UserModelZX.fromJson(response.responseData!);
          userModelZx.value = userModel;
          currentUser.value = userModel.user;
          authToken.value = userModel.token;
          isLoggedIn.value = true;

          await _saveToken(userModel.token);
          await _saveUserData(userModel.user);

          Get.snackbar(
            'সফল!',
            'লগইন সফল হয়েছে',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          Get.offAllNamed('/home');
        } else {
          errorMessage.value = 'Invalid response from server';
          Get.snackbar(
            'ত্রুটি!',
            'Invalid response from server',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = response.errorMessage ?? 'Login failed';
        Get.snackbar(
          'ত্রুটি!',
          response.errorMessage ?? 'Login failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'ত্রুটি!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load User Profile
  Future<void> loadUserProfile() async {
    try {
      final response = await _userZxRepository.getUserProfile();
      if (response.isSuccess && response.responseData != null) {
        final user = Userwer.fromJson(response.responseData!);
        currentUser.value = user;
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  // Update Profile
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String phone,
    required String email,
    String? image,
  }) async {
    try {
      isLoading.value = true;

      final response = await _userZxRepository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        username: username,
        phone: phone,
        email: email,
        image: image,
      );

      if (response.isSuccess && response.responseData != null) {
        final user = Userwer.fromJson(response.responseData!);
        currentUser.value = user;
        Get.snackbar(
          'সফল!',
          'প্রোফাইল আপডেট করা হয়েছে',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'ত্রুটি!',
          response.errorMessage ?? 'Profile update failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'ত্রুটি!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _userZxRepository.logout();
      await _clearStoredData();
      
      userModelZx.value = null;
      currentUser.value = null;
      authToken.value = '';
      isLoggedIn.value = false;
      isVerificationSuccess.value = false;
      isOtpSent.value = false;

      Get.offAllNamed('/login');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Reset OTP Status (call this when going back to OTP screen)
  void resetOtpStatus() {
    isVerificationSuccess.value = false;
    isOtpSent.value = false;
    errorMessage.value = '';
  }

  // Local Storage Methods
  Future<void> _saveToken(String token) async {
    // await GetStorage().write('auth_token', token);
  }

  Future<void> _saveUserData(Userwer user) async {
    // await GetStorage().write('user_data', user.toJson());
  }

  Future<String?> _getStoredToken() async {
    // return await GetStorage().read('auth_token');
    return null;
  }

  Future<void> _clearStoredData() async {
    // await GetStorage().erase();
  }

  // Getters
  String get userFullName => currentUser.value?.fullName ?? '';
  String get userEmail => currentUser.value?.email ?? '';
  String get userPhone => currentUser.value?.phone ?? '';
  String get userFirstName => currentUser.value?.firstName ?? '';
  String get userLastName => currentUser.value?.lastName ?? '';
  String? get userImage => currentUser.value?.image;
  String get token => authToken.value;
}