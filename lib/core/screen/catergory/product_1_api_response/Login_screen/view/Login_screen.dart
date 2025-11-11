// lib/core/screen/catergory/product_1_api_response/Login_screen/view/Login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/view/chek_out_view.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Forgot_password_Screen/view/forgot_password_view.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/view/registrtion_view.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/controller/login_controller.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final EpicAuthController _authController = Get.find<EpicAuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _autoCheckAndRedirect();
  }

  void _autoCheckAndRedirect() {
    print('🔍 ========== AUTO CHECK & REDIRECT ==========');
    print('🔐 User logged in: ${_authController.isLoggedIn.value}');
    
    // যদি user already logged in থাকে
    if (_authController.isLoggedIn.value &&
        _authController.authToken.isNotEmpty) {
      print('✅ User is ALREADY logged in');

      // Delay কমিয়ে দিন
      Future.delayed(Duration(milliseconds: 500), () {
        _handleAutoRedirect();
      });
    } else {
      print('🔒 User is NOT logged in, showing login form');
    }
  }

  void _handleAutoRedirect() {
    // যদি cart থেকে এসে থাকে
    if (Get.arguments != null && Get.arguments['fromCart'] == true) {
      print('🛒 Came from cart, redirecting to checkout');
      Get.offAll(() => CheckoutScreen());
    }
    // যদি pending action থাকে
    else if (_authController.pendingAction != null) {
      print('🎯 Pending action found, executing');
      _authController.pendingAction!();
      _authController.pendingAction = null;
    }
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    print('🔄 === LOGIN STARTED ===');

    final success = await _authController.executeUserLogin(
      emailAddress: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    print('✅ Login result: $success');
    
    if (success) {
      // Login successful - handle navigation
      _handlePostLoginNavigation();
    }
  }

  void _handlePostLoginNavigation() {
    // Small delay for smooth transition
    Future.delayed(Duration(milliseconds: 300), () {
      // যদি cart থেকে এসে থাকে
      if (Get.arguments != null && Get.arguments['fromCart'] == true) {
        print('🛒 Redirecting to checkout after login');
        Get.offAll(() => CheckoutScreen());
      }
      // যদি pending action থাকে
      else if (_authController.pendingAction != null) {
        print('🎯 Executing pending action after login');
        _authController.pendingAction!();
        _authController.pendingAction = null;
      }
      // সাধারণ case - home এ যাবে
      else {
        print('🏠 Login successful, going back or to home');
        if (Navigator.canPop(Get.context!)) {
          Get.back(result: true); // Success result দিয়ে back
        } else {
          Get.offAllNamed('/home'); // বা আপনার home route
        }
      }
    });
  }

  // ✅ FIXED: Forgot Password Navigation
  void _navigateToForgotPassword() {
    print('🔑 Navigating to Forgot Password');
    Get.to(
      () => const ForgotPasswordScreen(),
      // binding: ForgotPasswordBinder(), // যদি binder লাগে
      transition: Transition.rightToLeft,
      duration: Duration(milliseconds: 300),
    );
  }

  // ✅ FIXED: Registration Navigation
  void _navigateToRegistration() {
    print('📝 Navigating to Registration');
    Get.to(
      () => const SignUpScreen(),
      transition: Transition.rightToLeft,
      duration: Duration(milliseconds: 300),
    );
  }

  void _demoLogin() {
    _emailController.text = "eee@email.com";
    _passwordController.text = "password";

    // Auto login after setting demo credentials
    Future.delayed(Duration(milliseconds: 100), () {
      _login();
    });
  }

  // ✅ IMPROVED: Back Button Handling
  void _handleBackButton() {
    print('🔙 Back button pressed');

    if (Get.arguments != null && Get.arguments['fromCart'] == true) {
      // Cart থেকে এসে থাকলে cart এ ফিরে যাবে
      print('🛒 Returning to cart');
      Get.back(result: false); // login cancel result
    } else if (Navigator.canPop(Get.context!)) {
      print('⬅️ Normal back navigation');
      Get.back();
    } else {
      print('🏠 No back route, going to home');
      Get.offAllNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackButton();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button Only
                  IconButton(
                    onPressed: _handleBackButton,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textPrimary,
                    ),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildLoginForm(),
                  const SizedBox(height: 30),
                  _buildLoginButton(),
                  const SizedBox(height: 20),
                  const SizedBox(height: 30),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "লগইন করুন",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        "আপনার অ্যাকাউন্টে অ্যাক্সেস পেতে লগইন করুন",
        style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
      ),
    ],
  );

  Widget _buildLoginForm() => Column(
    children: [
      TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: "ইমেইল এড্রেস",
          labelStyle: TextStyle(color: AppColors.textSecondary),
          prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.primaryLight.withOpacity(0.1),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty)
            return 'দয়া করে আপনার ইমেইল এড্রেস লিখুন';
          if (!value.contains('@')) return 'দয়া করে সঠিক ইমেইল এড্রেস লিখুন';
          return null;
        },
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: "পাসওয়ার্ড",
          labelStyle: TextStyle(color: AppColors.textSecondary),
          prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.primaryLight.withOpacity(0.1),
        ),
        validator: (value) {
          if (value == null || value.isEmpty)
            return 'দয়া করে আপনার পাসওয়ার্ড লিখুন';
          if (value.length < 6) return 'পাসওয়ার্ড অন্তত ৬ ক্যারেক্টার হতে হবে';
          return null;
        },
      ),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: _navigateToForgotPassword,
          child: Text(
            "পাসওয়ার্ড ভুলে গেছেন?",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildLoginButton() => Obx(
    () => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _authController.isLoading.value ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
        ),
        child: _authController.isLoading.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                "লগইন করুন",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    ),
  );



  Widget _buildFooter() => Column(
    children: [
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("অ্যাকাউন্ট নেই? "),
          GestureDetector(
            onTap: _navigateToRegistration,
            child: Text(
              "এখানে রেজিস্ট্রেশন করুন",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ],
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}