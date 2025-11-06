// lib/core/screen/auth/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/sign_up_screen/otp_verificationa-screen/otp_verification_screen.dart';
import 'package:polli_e_commerce_app/core/widgets/auth_controller.dart';
import 'package:polli_e_commerce_app/routes/app_pages.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController _authController = Get.find();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  // lib/core/screen/auth/signup_screen.dart - _signUp() মেথড
  // lib/core/screen/auth/signup_screen.dart - _signUp() মেথড
  // lib/core/screen/auth/signup_screen.dart - _signUp() মেথড
  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      Get.snackbar(
        "শর্তাবলী গ্রহণ করুন",
        "রেজিস্ট্রেশন সম্পন্ন করতে আমাদের শর্তাবলী ও গোপনীয়তা নীতি গ্রহণ করুন",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    // Very short delay
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => _isLoading = false);

    // ✅ Simple navigation without animation
    Get.to(
      () => OtpVerificationScreen(
        email: _emailController.text,
        phone: _phoneController.text,
      ),
      transition: Transition.noTransition, // No animation
      duration: Duration.zero, // No delay
    );
  }

  void _demoSignUp() {
    _fullNameController.text = "জন ডো";
    _emailController.text = "user@example.com";
    _phoneController.text = "01712345678";
    _passwordController.text = "password";
    _confirmPasswordController.text = "password";
    _agreeToTerms = true;
  }

  void _navigateToLogin() {
    Get.back();
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
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.textPrimary,
                  ),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                const SizedBox(height: 20),

                // Header
                _buildHeader(),
                const SizedBox(height: 30),

                // Sign Up Form
                _buildSignUpForm(),
                const SizedBox(height: 20),

                // Terms and Conditions
                _buildTermsCheckbox(),
                const SizedBox(height: 30),

                // Sign Up Button
                _buildSignUpButton(),
                const SizedBox(height: 20),

                // Demo Button
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

  Widget _buildHeader() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "অ্যাকাউন্ট তৈরি করুন",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        "একটি নতুন অ্যাকাউন্ট তৈরি করুন এবং আমাদের সেবা উপভোগ করুন",
        style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
      ),
    ],
  );

  Widget _buildSignUpForm() => Column(
    children: [
      // Full Name Field
      TextFormField(
        controller: _fullNameController,
        decoration: InputDecoration(
          labelText: "পুরো নাম",
          labelStyle: TextStyle(color: AppColors.textSecondary),
          prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.primaryLight.withOpacity(0.1),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'দয়া করে আপনার পুরো নাম লিখুন';
          }
          if (value.length < 3) {
            return 'নাম অন্তত ৩ ক্যারেক্টার হতে হবে';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Email Field
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
          if (value == null || value.isEmpty) {
            return 'দয়া করে আপনার ইমেইল এড্রেস লিখুন';
          }
          if (!value.contains('@') || !value.contains('.')) {
            return 'দয়া করে সঠিক ইমেইল এড্রেস লিখুন';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Phone Field
      TextFormField(
        controller: _phoneController,
        decoration: InputDecoration(
          labelText: "মোবাইল নম্বর",
          labelStyle: TextStyle(color: AppColors.textSecondary),
          prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.primaryLight.withOpacity(0.1),
        ),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'দয়া করে আপনার মোবাইল নম্বর লিখুন';
          }
          if (value.length < 11) {
            return 'মোবাইল নম্বর সঠিক নয়';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

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
          if (value == null || value.isEmpty) {
            return 'দয়া করে আপনার পাসওয়ার্ড লিখুন';
          }
          if (value.length < 6) {
            return 'পাসওয়ার্ড অন্তত ৬ ক্যারেক্টার হতে হবে';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Confirm Password Field
      TextFormField(
        controller: _confirmPasswordController,
        obscureText: _obscureConfirmPassword,
        decoration: InputDecoration(
          labelText: "পাসওয়ার্ড নিশ্চিত করুন",
          labelStyle: TextStyle(color: AppColors.textSecondary),
          prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
            ),
            onPressed: () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword,
            ),
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
          if (value == null || value.isEmpty) {
            return 'দয়া করে পাসওয়ার্ড নিশ্চিত করুন';
          }
          if (value != _passwordController.text) {
            return 'পাসওয়ার্ড মিলছে না';
          }
          return null;
        },
      ),
    ],
  );

  Widget _buildTermsCheckbox() => Row(
    children: [
      Checkbox(
        value: _agreeToTerms,
        onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
        activeColor: AppColors.primary,
        checkColor: Colors.white,
      ),
      Expanded(
        child: Wrap(
          children: [
            Text(
              "আমি গ্রহণ করছি ",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            GestureDetector(
              onTap: () => Get.snackbar(
                "সেবার শর্তাবলী",
                "শীঘ্রই আসছে",
                snackPosition: SnackPosition.BOTTOM,
              ),
              child: Text(
                "সেবার শর্তাবলী",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(" ও ", style: TextStyle(color: AppColors.textSecondary)),
            GestureDetector(
              onTap: () => Get.snackbar(
                "গোপনীয়তা নীতি",
                "শীঘ্রই আসছে",
                snackPosition: SnackPosition.BOTTOM,
              ),
              child: Text(
                "গোপনীয়তা নীতি",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildSignUpButton() => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _signUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          : const Text(
              "অ্যাকাউন্ট তৈরি করুন",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
    ),
  );

  Widget _buildDemoButton() => SizedBox(
    width: double.infinity,
    height: 50,
    child: OutlinedButton(
      onPressed: _demoSignUp,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        "ডেমো তথ্য ব্যবহার করুন (টেস্ট)",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
  );

  Widget _buildFooter() => Column(
    children: [
      Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "অথবা",
              style: TextStyle(color: AppColors.textSecondary),
            ),
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
            onPressed: () => Get.snackbar("গুগল সাইন আপ", "শীঘ্রই আসছে"),
          ),
          const SizedBox(width: 16),
          _buildSocialButton(
            icon: Icons.facebook,
            onPressed: () => Get.snackbar("ফেসবুক সাইন আপ", "শীঘ্রই আসছে"),
          ),
          const SizedBox(width: 16),
          _buildSocialButton(
            icon: Icons.phone,
            onPressed: () => Get.snackbar("ফোন সাইন আপ", "শীঘ্রই আসছে"),
          ),
        ],
      ),
      const SizedBox(height: 30),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("ইতিমধ্যে অ্যাকাউন্ট আছে? "),
          GestureDetector(
            onTap: _navigateToLogin,
            child: Text(
              "লগইন করুন",
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
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
