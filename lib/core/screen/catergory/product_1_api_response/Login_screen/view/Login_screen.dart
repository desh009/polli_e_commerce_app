import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/view/chek_out_view.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/controller/login_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/forgot_password.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/sign_up_screen/sign_up_screen.dart';
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
    print(
      '🔑 Auth token: ${_authController.authToken.value.isNotEmpty ? "EXISTS" : "EMPTY"}',
    );
    print('🔍 Pending action: ${_authController.pendingAction != null}');
    print('📍 Current route: ${Get.currentRoute}');
    print('📦 Arguments: ${Get.arguments}');

    // যদি user already logged in থাকে
    if (_authController.isLoggedIn.value &&
        _authController.authToken.isNotEmpty) {
      print('✅ User is ALREADY logged in, checking for redirection');

      // যদি cart থেকে এসে থাকে
      if (Get.arguments != null && Get.arguments['fromCart'] == true) {
        print('🛒 Came from cart, redirecting to checkout immediately');
        Future.delayed(Duration(milliseconds: 1500), () {
          Get.offAll(() => CheckoutScreen());
        });
      }
      // যদি pending action থাকে
      else if (_authController.pendingAction != null) {
        print('🎯 Pending action found, executing');
        Future.delayed(Duration(milliseconds: 1500), () {
          _authController.pendingAction!();
          _authController.pendingAction = null;
        });
      }
      // সাধারণ login screen এ এসে থাকে
      else {
        print('ℹ️ Already logged in, showing login screen');
        // Pre-fill email if user data exists
        if (_authController.epicUserData.value != null) {
          _emailController.text =
              _authController.epicUserData.value!.emailAddress;
        }
      }
    } else {
      print('🔒 User is NOT logged in, showing login form');
    }
  }

  // lib/core/screen/catergory/product_1_api_response/Login_screen/view/Login_screen.dart
  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    print('🔄 === LOGIN STARTED ===');
    print('🔍 Pending action before: ${_authController.pendingAction != null}');

    final success = await _authController.executeUserLogin(
      emailAddress: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    print('✅ Login result: $success');
    print('🔍 Pending action after: ${_authController.pendingAction != null}');

    // ✅ EI PART E KICHU KORA LAGBE NA
    // AuthController automatically handle korbe
  }

  void _navigateToForgotPassword() {
    Get.to(() => const ForgotPasswordScreen());
  }

  void _demoLogin() {
    _emailController.text = "eee@email.com";
    _passwordController.text = "password";

    // ✅ TEST: Simulate checkout scenario
    _authController.pendingAction = () {
      print('🛒 TEST: Navigating to CheckoutScreen from demo');
      Get.offAll(() => CheckoutScreen());
    };

    print('🎯 Demo login with pending action set for checkout');
    _login();
  }

  void _handleBackButton() {
    print('🔙 Back button pressed, current route: ${Get.currentRoute}');

    if (Navigator.canPop(Get.context!)) {
      print('⬅️ Popping current screen');
      Get.back();
    } else {
      print('🏠 No previous screen, going to home');
      Get.offAllNamed('/');
    }
  }

  // ✅ NEW: Add debug method to check status
  void _debugStatus() {
    print('=== DEBUG STATUS ===');
    print('🔐 Logged In: ${_authController.isLoggedIn.value}');
    print('🎯 Pending Action: ${_authController.pendingAction != null}');
    print('📍 Current Route: ${Get.currentRoute}');
    print('📦 Arguments: ${Get.arguments}');
    print('===================');
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
                  // ✅ ADD DEBUG BUTTON
                  Row(
                    children: [
                      IconButton(
                        onPressed: _handleBackButton,
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.textPrimary,
                        ),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: _debugStatus,
                        icon: Icon(Icons.bug_report, color: Colors.red),
                        tooltip: 'Debug Status',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildLoginForm(),
                  const SizedBox(height: 30),
                  _buildLoginButton(),
                  const SizedBox(height: 20),
                  _buildDemoButton(),
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

  Widget _buildDemoButton() => SizedBox(
    width: double.infinity,
    height: 50,
    child: OutlinedButton(
      onPressed: _demoLogin,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        "ডেমো লগইন (টেস্ট)",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
  );

  Widget _buildFooter() => Column(
    children: [
      Row(
        children: [
          const Expanded(child: Divider()),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("অথবা"),
          ),
          const Expanded(child: Divider()),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSocialButton(
            icon: Icons.g_mobiledata,
            onPressed: () => Get.snackbar("গুগল লগইন", "শীঘ্রই আসছে"),
          ),
          const SizedBox(width: 16),
          _buildSocialButton(
            icon: Icons.facebook,
            onPressed: () => Get.snackbar("ফেসবুক লগইন", "শীঘ্রই আসছে"),
          ),
          const SizedBox(width: 16),
          _buildSocialButton(
            icon: Icons.phone,
            onPressed: () => Get.snackbar("ফোন লগইন", "শীঘ্রই আসছে"),
          ),
        ],
      ),
      const SizedBox(height: 30),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("অ্যাকাউন্ট নেই? "),
          GestureDetector(
            onTap: () => Get.to(() => const SignUpScreen()),
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

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) => CircleAvatar(
    backgroundColor: AppColors.primaryLight.withOpacity(0.2),
    radius: 24,
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: AppColors.primary),
    ),
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
