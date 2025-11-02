// lib/core/screen/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/forgot_password.dart';
import 'package:polli_e_commerce_app/core/widgets/auth_controller.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.find();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // ✅ Login logic
      _authController.login();
      
      setState(() {
        _isLoading = false;
      });
      
      Get.back(); // Close login screen
      
      Get.snackbar(
        "লগইন সফল!",
        "আপনার অ্যাকাউন্টে সফলভাবে লগইন করা হয়েছে",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
   
  void _navigateToForgotPassword() {
    Get.to(() => const ForgotPasswordScreen()); // ✅ Navigate to forgot password
  }
    
  void _demoLogin() {
    _emailController.text = "user@example.com";
    _passwordController.text = "password";
    _login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                
                const SizedBox(height: 20),
                
                // Header Section
                _buildHeader(),
                const SizedBox(height: 40),
                
                // Login Form
                _buildLoginForm(),
                const SizedBox(height: 30),
                
                // Login Button
                _buildLoginButton(),
                const SizedBox(height: 20),
                
                // Demo Login Button
                _buildDemoButton(),
                const SizedBox(height: 30),
                
                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
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
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        // Email Field
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "ইমেইল এড্রেস",
            labelStyle: TextStyle(color: AppColors.textSecondary),
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textSecondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.primaryLight.withOpacity(0.1),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'দয়া করে আপনার ইমেইল এড্রেস লিখুন';
            }
            if (!value.contains('@')) {
              return 'দয়া করে সঠিক ইমেইল এড্রেস লিখুন';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        
        // Password Field
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
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textSecondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.primaryLight.withOpacity(0.1),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'দয়া করে আপনার পাসওয়ার্ড লিখুন';
            }
            if (value.length < 6) {
              return 'পাসওয়ার্ড অন্তত ৬ ক্যারেক্টার হতে হবে';
            }
            return null;
          },
        ),
        
        // Forgot Password (Updated)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _navigateToForgotPassword, // ✅ Updated to navigate
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
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                "লগইন করুন",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildDemoButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: _demoLogin,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "ডেমো লগইন (টেস্ট)",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(color: AppColors.textSecondary),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "অথবা",
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            Expanded(
              child: Divider(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Social Login Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google Login
            _buildSocialButton(
              icon: Icons.g_mobiledata,
              onPressed: () {
                Get.snackbar(
                  "গুগল লগইন",
                  "গুগল লগইন খুব শীঘ্রই আসছে",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.accent,
                  colorText: Colors.white,
                );
              },
            ),
            const SizedBox(width: 16),
            
            // Facebook Login
            _buildSocialButton(
              icon: Icons.facebook,
              onPressed: () {
                Get.snackbar(
                  "ফেসবুক লগইন",
                  "ফেসবুক লগইন খুব শীঘ্রই আসছে",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF1877F2),
                  colorText: Colors.white,
                );
              },
            ),
            const SizedBox(width: 16),
            
            // Phone Login
            _buildSocialButton(
              icon: Icons.phone,
              onPressed: () {
                Get.snackbar(
                  "ফোন লগইন",
                  "ফোন লগইন খুব শীঘ্রই আসছে",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.primary,
                  colorText: Colors.white,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
        
        // Sign Up Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "অ্যাকাউন্ট নেই? ",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            GestureDetector(
              onTap: () {
                Get.snackbar(
                  "রেজিস্ট্রেশন",
                  "রেজিস্ট্রেশন খুব শীঘ্রই আসছে",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.accent,
                  colorText: Colors.white,
                );
              },
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
  }

  Widget _buildSocialButton({required IconData icon, required VoidCallback onPressed}) {
    return CircleAvatar(
      backgroundColor: AppColors.primaryLight.withOpacity(0.2),
      radius: 24,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.primary),
        iconSize: 24,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}