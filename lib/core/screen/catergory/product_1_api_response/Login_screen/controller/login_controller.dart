// lib/core/widgets/auth_controller.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/view/chek_out_view.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/view/Login_screen.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/auth_response/auth_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/login_response/login_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/repository/login_repository.dart';
import 'package:polli_e_commerce_app/moduls/Log_out/repostory/log_out_repository.dart';

class EpicAuthController extends GetxController {
  late final EpicAuthRepository _authRepository;
  late final LogoutRepository _logoutRepository;
  final GetStorage _storage = GetStorage();

  // Observable variables
  var isLoading = false.obs;
  var epicUserData = Rx<EpicUserData?>(null);
  var authToken = RxString('');
  var isLoggedIn = false.obs;

  // Pending action after login
  VoidCallback? pendingAction;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
    _loadStoredUserData();
  }

  void _initializeRepository() {
    final networkClient = Get.find<NetworkClient>();
    _authRepository = EpicAuthRepository(networkClient: networkClient);
    _logoutRepository = LogoutRepository(networkClient: networkClient);
    print('✅ EpicAuthRepository & LogoutRepository initialized');
  }

  // 📥 Load stored user data - FIXED
  void _loadStoredUserData() {
    try {
      print('📥 ========== LOADING STORED USER DATA ==========');
      final storedToken = _storage.read('auth_token');
      final storedUser = _storage.read('user_data');

      print('🔐 Stored token: ${storedToken != null ? "EXISTS" : "NULL"}');
      print('👤 Stored user: ${storedUser != null ? "EXISTS" : "NULL"}');

      if (storedToken != null && storedUser != null && storedToken.isNotEmpty) {
        authToken.value = storedToken;
        epicUserData.value = EpicUserData.fromJson(storedUser);
        isLoggedIn.value = true;

        print('✅ User data loaded successfully from storage');
        print('✅ Token length: ${authToken.value.length}');
        print('✅ isLoggedIn: ${isLoggedIn.value}');
        print('✅ User: ${epicUserData.value?.completeName}');
      } else {
        print('ℹ️ No valid stored user data found');
        isLoggedIn.value = false;
        authToken.value = '';
        _clearInvalidStorageData();
      }
    } catch (e) {
      print('❌ Error loading stored data: $e');
      isLoggedIn.value = false;
      authToken.value = '';
      _clearInvalidStorageData();
    }
  }

  // 🗑️ Clear invalid storage data
  void _clearInvalidStorageData() {
    try {
      _storage.remove('auth_token');
      _storage.remove('user_data');
      print('✅ Cleared invalid storage data');
    } catch (e) {
      print('❌ Error clearing invalid storage: $e');
    }
  }

  // 💾 Save user data to storage - FIXED
  void _saveUserData(EpicAuthResponse response) {
    try {
      print('💾 ========== SAVING USER DATA ==========');
      print('🔐 New Token: ${response.authToken}');
      print('👤 User: ${response.userData.completeName}');

      // Clear previous data first
      _clearUserData();

      // Save new data
      _storage.write('auth_token', response.authToken);
      _storage.write('user_data', response.userData.toJson());
      _storage.write('is_logged_in', true);
      
      // Update reactive variables
      authToken.value = response.authToken;
      epicUserData.value = response.userData;
      isLoggedIn.value = true;

      // Verify save
      final savedToken = _storage.read('auth_token');
      final savedUser = _storage.read('user_data');
      final savedLoginStatus = _storage.read('is_logged_in');

      print('✅ Storage verification - Token: ${savedToken != null ? "SAVED" : "NOT SAVED"}');
      print('✅ Storage verification - User: ${savedUser != null ? "SAVED" : "NOT SAVED"}');
      print('✅ Storage verification - Login Status: $savedLoginStatus');
      print('✅ AuthToken Rx: ${authToken.value.isNotEmpty ? "SET" : "EMPTY"}');
      print('✅ isLoggedIn Rx: ${isLoggedIn.value}');
    } catch (e) {
      print('❌ Error saving user data: $e');
    }
  }

  // 🗑️ Clear user data from storage - COMPLETELY FIXED
  void _clearUserData() {
    try {
      print('🗑️ ========== CLEARING USER DATA ==========');
      
      // Clear storage
      _storage.remove('auth_token');
      _storage.remove('user_data');
      _storage.remove('is_logged_in');
      _storage.remove('email_verified');
      
      // Clear reactive variables
      epicUserData.value = null;
      authToken.value = '';
      isLoggedIn.value = false;
      pendingAction = null;
      
      // Force update
      update();
      
      print('✅ User data completely cleared from storage and memory');
      print('✅ AuthToken after clear: ${authToken.value.isEmpty ? "EMPTY" : "STILL_HAS_DATA"}');
      print('✅ isLoggedIn after clear: ${isLoggedIn.value}');
      print('✅ UserData after clear: ${epicUserData.value == null ? "NULL" : "STILL_HAS_DATA"}');
    } catch (e) {
      print('❌ Error clearing user data: $e');
    }
  }

  // 🔐 Login Method - COMPLETELY FIXED
  Future<bool> executeUserLogin({
    required String emailAddress,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      print('🔄 ========== LOGIN PROCESS STARTED ==========');
      print('📧 Email: $emailAddress');
      print('🔐 Previous login status: ${isLoggedIn.value}');

      final response = await _authRepository.performUserLogin(
        emailAddress: emailAddress,
        password: password,
      );

      if (response.isSuccess) {
        print('✅ Login API successful: ${response.userData.completeName}');
        
        // Save user data
        _saveUserData(response);

        // Show success message
        Get.snackbar(
          'লগইন সফল! 🎉',
          'স্বাগতম ${response.userData.completeName}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        // Navigate after login
        _navigateAfterLogin();
        return true;
      } else {
        throw Exception(response.message ?? 'Login failed');
      }
    } catch (e) {
      print('❌ Login error: $e');
      
      String errorMessage = "লগইন ব্যর্থ হয়েছে";
      String errorDetails = e.toString().replaceAll('Exception:', '').trim();
      
      if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        errorMessage = "ইমেইল বা পাসওয়ার্ড ভুল";
        errorDetails = "দয়া করে সঠিক তথ্য দিন";
      } else if (e.toString().contains('500')) {
        errorMessage = "সার্ভার সমস্যা";
        errorDetails = "দয়া করে কিছুক্ষণ পর চেষ্টা করুন";
      } else if (e.toString().contains('Network') || e.toString().contains('Socket')) {
        errorMessage = "ইন্টারনেট সংযোগ নেই";
        errorDetails = "দয়া করে ইন্টারনেট সংযোগ চেক করুন";
      }
      
      Get.snackbar(
        errorMessage,
        errorDetails,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Navigation after login - FIXED
  void _navigateAfterLogin() {
    print('🔄 ========== NAVIGATION AFTER LOGIN ==========');
    print('📍 Current route: ${Get.currentRoute}');
    print('🔍 Pending action: ${pendingAction != null ? "EXISTS" : "NULL"}');

    // Close login screen if open
    if (Get.currentRoute == '/login' || Get.currentRoute.contains('LoginScreen')) {
      print('📱 Closing login screen...');
      Get.back();
    }

    // Execute pending action if exists
    if (pendingAction != null) {
      print('🎯 Executing pending action after login');
      
      final savedAction = pendingAction;
      pendingAction = null;

      Future.delayed(Duration(milliseconds: 800), () {
        print('🚀 Executing saved pending action');
        try {
          savedAction!();
          print('✅ Pending action executed successfully');
        } catch (e) {
          print('❌ Error executing pending action: $e');
          // Fallback to home
          Get.offAllNamed('/');
        }
      });
    } else {
      print('💡 No pending action found, navigating to home');
      // Navigate to home screen
      Future.delayed(Duration(milliseconds: 500), () {
        Get.offAllNamed('/');
      });
    }
  }

  // 🚪 Logout Method - COMPLETELY FIXED
  Future<void> executeUserLogout() async {
    try {
      isLoading.value = true;
      print('🔄 ========== LOGOUT PROCESS STARTED ==========');
      print('🔐 Current login status: ${isLoggedIn.value}');
      print('🔐 Token exists: ${authToken.value.isNotEmpty}');

      bool serverLogoutSuccess = false;

      // ✅ Only call server logout if we have valid token and are logged in
      if (authToken.value.isNotEmpty && isLoggedIn.value) {
        try {
          print('📡 Calling server logout API...');
          serverLogoutSuccess = await _logoutRepository.performUserLogout();
          
          if (serverLogoutSuccess) {
            print('✅ Server logout successful');
          } else {
            print('⚠️ Server logout failed, but continuing with local logout');
          }
        } catch (e) {
          print('❌ Server logout API error: $e');
          // Continue with local logout even if server fails
        }
      } else {
        print('ℹ️ No valid token found, performing local logout only');
      }

      // ✅ ALWAYS clear local data (whether server logout succeeded or failed)
      _clearUserData();

      // Show success message
      Get.snackbar(
        'লগআউট সফল ✅',
        'আপনি সফলভাবে লগআউট হয়েছেন',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      print('✅ Logout process completed successfully');

      // ✅ Navigate to HOME SCREEN (not splash)
      _navigateAfterLogout();

    } catch (e) {
      print('❌ Critical logout error: $e');
      
      // ✅ EMERGENCY: Clear data even if everything fails
      _clearUserData();
      
      Get.snackbar(
        'সেশন ক্লিয়ার হয়েছে',
        'স্থানীয় ডেটা সাফ করা হয়েছে',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      
      _navigateAfterLogout();
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Navigation after logout - FIXED
  void _navigateAfterLogout() {
    print('🎯 ========== NAVIGATION AFTER LOGOUT ==========');
    print('📍 Current route before navigation: ${Get.currentRoute}');
    
    try {
      // Use offAllNamed to clear navigation stack and go to home
      Get.offAllNamed('/');
      
      print('✅ Successfully navigated to home screen after logout');
      
      // Verify navigation
      Future.delayed(Duration(milliseconds: 500), () {
        print('📍 Current route after navigation: ${Get.currentRoute}');
      });
    } catch (e) {
      print('❌ Navigation error after logout: $e');
      
      // Fallback navigation
      try {
        Get.until((route) => route.isFirst);
        print('✅ Fallback navigation successful');
      } catch (e2) {
        print('❌ Fallback navigation also failed: $e2');
      }
    }
  }

  // ========== SIMPLE AUTH METHODS ========== //

  void onLoginSuccess() {
    print('🎯 Login successful, checking pending actions...');
    if (pendingAction != null) {
      print('🚀 Executing pending buy now action');
      final savedAction = pendingAction;
      pendingAction = null;
      Future.delayed(Duration(milliseconds: 500), () {
        savedAction!();
      });
    } else {
      print('💡 No pending action after login');
    }
  }

  void login() {
    isLoggedIn.value = true;
    pendingAction?.call();
    pendingAction = null;
  }

  void logout() {
    _clearUserData();
  }

  void checkAuthAndExecute(VoidCallback action) {
    if (isLoggedIn.value && authToken.value.isNotEmpty) {
      action();
    } else {
      pendingAction = action;
      Get.to(() => LoginScreen());
    }
  }

  void requireAuthentication(VoidCallback action) {
    if (isLoggedIn.value && authToken.value.isNotEmpty) {
      action();
    } else {
      pendingAction = action;
      print('🔒 Authentication required, redirecting to login');
      Get.to(() => LoginScreen());
    }
  }

  // Get user full name
  String get userFullName => epicUserData.value?.completeName ?? 'User';

  // Get user email
  String get userEmail => epicUserData.value?.emailAddress ?? '';

  // Check if email is verified
  bool get isEmailVerified => epicUserData.value?.isEmailConfirmed == 1;

  // Get auth token
  String get token => authToken.value;

  // Check if user is authenticated
  bool get isAuthenticated => isLoggedIn.value && authToken.value.isNotEmpty;

  // ✅ NEW: Force clear everything (for emergency)
  void forceLogout() {
    print('🚨 FORCE LOGOUT CALLED');
    _clearUserData();
    Get.offAllNamed('/');
  }

  // ✅ NEW: Check if user data is valid
  bool get hasValidUserData => 
      isLoggedIn.value && 
      authToken.value.isNotEmpty && 
      epicUserData.value != null;
}