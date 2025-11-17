import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/controller/registration_controller.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final RegistrationController _registrationController =
      Get.find<RegistrationController>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _localLoading = false;

  @override
  void initState() {
    super.initState();
    print('🎯 SignUpScreen initialized');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ✅ FIXED: _signUp method
  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      Get.snackbar(
        "শর্তাবলী গ্রহণ করুন",
        "রেজিস্ট্রেশন সম্পন্ন করতে আমাদের শর্তাবলী ও গোপনীয়তা নীতি গ্রহণ করুন",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      print('🔄 Starting registration process...');

      // Set data to registration controller
      _registrationController.firstNameController.text = _firstNameController.text.trim();
      _registrationController.lastNameController.text = _lastNameController.text.trim();
      _registrationController.usernameController.text = _usernameController.text.trim();
      _registrationController.emailController.text = _emailController.text.trim();
      _registrationController.phoneController.text = _phoneController.text.trim();
      _registrationController.passwordController.text = _passwordController.text.trim();
      _registrationController.confirmPasswordController.text = _confirmPasswordController.text.trim();

      // ✅ FIXED: Show loading immediately (2-second delay remove করুন)
      setState(() {
        _localLoading = true;
      });

      // ✅ Call registration API immediately
      await _registrationController.registerUser();

    } catch (e) {
      print('❌ Registration error: $e');
      if (mounted) {
        setState(() {
          _localLoading = false;
        });
      }
      Get.snackbar(
        "রেজিস্ট্রেশন ব্যর্থ",
        "দয়া করে আবার চেষ্টা করুন",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      if (mounted) {
        setState(() {
          _localLoading = false;
        });
      }
    }
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
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Get.back();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.textPrimary,
                  ),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 30),
                _buildSignUpForm(),
                const SizedBox(height: 20),
                _buildVerificationNotice(),
                const SizedBox(height: 16),
                _buildTermsCheckbox(),
                const SizedBox(height: 30),
                _buildSignUpButton(),
                const SizedBox(height: 20),
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
        "একটি নতুন অ্যাকাউন্ট তৈরি করুন এবং ইমেইল ভেরিফিকেশন সম্পন্ন করুন",
        style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
      ),
    ],
  );

  Widget _buildSignUpForm() => Column(
    children: [
      TextFormField(
        controller: _firstNameController,
        decoration: InputDecoration(
          labelText: "নাম",
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
          if (value == null || value.isEmpty) return 'দয়া করে আপনার নাম লিখুন';
          if (value.length < 2) return 'নাম অন্তত ২ ক্যারেক্টার হতে হবে';
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _lastNameController,
        decoration: InputDecoration(
          labelText: "উপাধি",
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
          if (value == null || value.isEmpty) return 'দয়া করে আপনার উপাধি লিখুন';
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(
          labelText: "ইউজারনেম",
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
          if (value == null || value.isEmpty) return 'দয়া করে আপনার ইউজারনেম লিখুন';
          if (value.length < 4) return 'ইউজারনেম অন্তত ৪ ক্যারেক্টার হতে হবে';
          return null;
        },
      ),
      const SizedBox(height: 16),
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
          if (value == null || value.isEmpty) return 'দয়া করে আপনার ইমেইল এড্রেস লিখুন';
          if (!value.contains('@') || !value.contains('.')) return 'দয়া করে সঠিক ইমেইল এড্রেস লিখুন';
          return null;
        },
      ),
      const SizedBox(height: 16),
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
          if (value == null || value.isEmpty) return 'দয়া করে আপনার মোবাইল নম্বর লিখুন';
          if (value.length < 11) return 'মোবাইল নম্বর সঠিক নয়';
          return null;
        },
      ),
      const SizedBox(height: 16),
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
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
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
          if (value == null || value.isEmpty) return 'দয়া করে আপনার পাসওয়ার্ড লিখুন';
          if (value.length < 6) return 'পাসওয়ার্ড অন্তত ৬ ক্যারেক্টার হতে হবে';
          return null;
        },
      ),
      const SizedBox(height: 16),
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
            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
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
          if (value == null || value.isEmpty) return 'দয়া করে পাসওয়ার্ড নিশ্চিত করুন';
          if (value != _passwordController.text) return 'পাসওয়ার্ড মিলছে না';
          return null;
        },
      ),
    ],
  );

  Widget _buildVerificationNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ইমেইল ভেরিফিকেশন আবশ্যক",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "রেজিস্ট্রেশন সাবমিট হলে আপনার ইমেইলে একটি ভেরিফিকেশন লিংক পাঠানো হবে। লিংকটি ক্লিক করার পরই অটোমেটিক রেজিস্ট্রেশন কনফার্ম হবে।",
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                duration: const Duration(seconds: 2),
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
                duration: const Duration(seconds: 2),
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

  Widget _buildSignUpButton() {
    return Obx(() {
      final isLoading = _registrationController.isLoading.value || _localLoading;

      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: isLoading ? null : _signUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "রেজিস্ট্রেশন হচ্ছে...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : Text(
                  "অ্যাকাউন্ট তৈরি করুন",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
        ),
      );
    });
  }

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
            onPressed: () => Get.snackbar("গুগল সাইন আপ", "শীঘ্রই আসছে", duration: const Duration(seconds: 2)),
          ),
          const SizedBox(width: 16),
          _buildSocialButton(
            icon: Icons.facebook,
            onPressed: () => Get.snackbar("ফেসবুক সাইন আপ", "শীঘ্রই আসছে", duration: const Duration(seconds: 2)),
          ),
          const SizedBox(width: 16),
          _buildSocialButton(
            icon: Icons.phone,
            onPressed: () => Get.snackbar("ফোন সাইন আপ", "শীঘ্রই আসছে", duration: const Duration(seconds: 2)),
          ),
        ],
      ),
      const SizedBox(height: 30),
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
}