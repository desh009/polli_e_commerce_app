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
  late final LogoutRepository _logoutRepository; // ✅ Add logout repository
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
    _logoutRepository = LogoutRepository(networkClient: networkClient); // ✅ Initialize
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

      if (storedToken != null && storedUser != null) {
        authToken.value = storedToken;
        epicUserData.value = EpicUserData.fromJson(storedUser);
        isLoggedIn.value = true;

        print('✅ User data loaded successfully from storage');
        print('✅ Token: ${authToken.value}');
        print('✅ isLoggedIn: ${isLoggedIn.value}');
        print('✅ User: ${epicUserData.value?.completeName}');
      } else {
        print('ℹ️ No stored user data found');
        isLoggedIn.value = false;
        authToken.value = '';
      }
    } catch (e) {
      print('❌ Error loading stored data: $e');
      isLoggedIn.value = false;
      authToken.value = '';
    }
  }

  // 💾 Save user data to storage - FIXED
  void _saveUserData(EpicAuthResponse response) {
    try {
      print('💾 ========== SAVING USER DATA ==========');
      print('🔐 New Token: ${response.authToken}');
      print('👤 User: ${response.userData.completeName}');

      _storage.write('auth_token', response.authToken);
      _storage.write('user_data', response.userData.toJson());
      authToken.value = response.authToken;
      isLoggedIn.value = true;

      // Verify save
      final savedToken = _storage.read('auth_token');
      final savedUser = _storage.read('user_data');

      print('✅ Storage verification - Token: ${savedToken != null ? "SAVED" : "NOT SAVED"}');
      print('✅ Storage verification - User: ${savedUser != null ? "SAVED" : "NOT SAVED"}');
      print('✅ AuthToken Rx: ${authToken.value}');
      print('✅ isLoggedIn Rx: ${isLoggedIn.value}');
    } catch (e) {
      print('❌ Error saving user data: $e');
    }
  }

  // 🗑️ Clear user data from storage
  void _clearUserData() {
    _storage.remove('auth_token');
    _storage.remove('user_data');
    epicUserData.value = null;
    authToken.value = '';
    isLoggedIn.value = false;
    pendingAction = null;
    print('✅ User data cleared from storage');
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
      print('🔐 User logged in before: ${isLoggedIn.value}');
      print('🔍 Pending action: ${pendingAction != null}');

      final response = await _authRepository.performUserLogin(
        emailAddress: emailAddress,
        password: password,
      );

      if (response.isSuccess) {
        epicUserData.value = response.userData;
        isLoggedIn.value = true;
        _saveUserData(response);

        Get.snackbar(
          'Welcome!',
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        print('✅ Login successful: ${response.userData.completeName}');
        _navigateAfterLogin();
        return true;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('❌ Login error: $e');
      Get.snackbar(
        'Login Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Navigation after login
  void _navigateAfterLogin() {
    print('🔄 ========== NAVIGATION AFTER LOGIN ==========');
    print('📍 Current route: ${Get.currentRoute}');
    print('🔍 Pending action: ${pendingAction != null ? "EXISTS" : "NULL"}');

    if (pendingAction != null) {
      print('🎯 Executing pending action after login');
      
      final savedAction = pendingAction;
      pendingAction = null;

      if (Get.currentRoute == '/login' || Get.currentRoute.contains('LoginScreen')) {
        print('📱 Closing login screen...');
        Get.back();
      }

      Future.delayed(Duration(milliseconds: 500), () {
        print('🚀 Executing saved pending action');
        try {
          savedAction!();
          print('✅ Pending action executed successfully');
        } catch (e) {
          print('❌ Error executing pending action: $e');
          Get.offAll(() => CheckoutScreen());
        }
      });
    } else {
      print('💡 No pending action found');
      if (Get.currentRoute == '/login' || Get.currentRoute.contains('LoginScreen')) {
        Get.back();
      }
    }
  }

  // 🚪 Logout Method - UPDATED with repository
// lib/core/widgets/auth_controller.dart - Updated logout method
Future<void> executeUserLogout() async {
  try {
    isLoading.value = true;
    print('🔄 ========== LOGOUT PROCESS STARTED ==========');
    print('🔐 Current token status: ${authToken.value.isNotEmpty ? "EXISTS" : "EMPTY"}');
    print('🔐 Token valid check: ${isLoggedIn.value}');

    bool serverLogoutSuccess = false;

    // ✅ CHECK: Token valid thaklei server logout call korbo
    if (authToken.isNotEmpty && isLoggedIn.value) {
      print('📡 Calling server logout API...');
      serverLogoutSuccess = await _logoutRepository.performUserLogout();
      
      if (serverLogoutSuccess) {
        print('✅ Server logout successful');
      } else {
        print('⚠️ Server logout failed, but continuing with local logout');
      }
    } else {
      print('ℹ️ Token already invalid/empty, performing local logout only');
    }

    // ✅ ALWAYS clear local data (token valid/invalid jai hok)
    _clearUserData();

    Get.snackbar(
      'Logged Out ✅',
      'You have been successfully logged out',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );

    print('✅ Logout process completed');

    // ✅ Navigate to home screen
    Get.offAllNamed('/');

  } catch (e) {
    print('❌ Logout error: $e');
    
    // ✅ Emergency: Clear data even if everything fails
    _clearUserData();
    
    Get.snackbar(
      'Session Cleared',
      'Local data cleared successfully',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
    
    Get.offAllNamed('/');
  } finally {
    isLoading.value = false;
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
    isLoggedIn.value = false;
    _clearUserData();
  }

  void checkAuthAndExecute(VoidCallback action) {
    if (isLoggedIn.value) {
      action();
    } else {
      pendingAction = action;
      Get.to(() => LoginScreen());
    }
  }

  void requireAuthentication(VoidCallback action) {
    if (isLoggedIn.value) {
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
  bool get isAuthenticated => isLoggedIn.value && authToken.isNotEmpty;
}