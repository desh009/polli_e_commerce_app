// lib/core/screen/auth/signup_screen.dart
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

  // Auto approval check variables
  var _isCheckingApproval = false.obs;
  var _approvalCheckCount = 0.obs;
  final int _maxApprovalChecks = 30;

  @override
  void initState() {
    super.initState();
    _stopApprovalCheck();
    _registrationController.stopAutoApprovalCheck();
    _registrationController.resetForm(); // Reset form when screen opens
  }

  @override
  void dispose() {
    _stopApprovalCheck();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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

      // Call registration API
      await _registrationController.registerUser();

      // ✅ FIXED: Check if we need to start approval check (only if email NOT verified)
      if (_registrationController.isWaitingForApproval.value) {
        print('🎯 Starting auto approval check - email verification pending');
        _startAutoApprovalCheck();
      } else if (_registrationController.registrationData.value != null) {
        // ✅ If email is already verified, go directly to login
        print('✅ Email already verified - registration complete');
        _handleRegistrationSuccess();
      }

    } catch (e) {
      print('❌ Registration error: $e');
      Get.snackbar(
        "রেজিস্ট্রেশন ব্যর্থ",
        "দয়া করে আবার চেষ্টা করুন বা ইন্টারনেট কানেকশন চেক করুন",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _startAutoApprovalCheck() {
    _isCheckingApproval.value = true;
    _approvalCheckCount.value = 0;

    print('🔄 Starting auto approval check for: ${_emailController.text}');

    // Start the checking loop
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 10));

      if (_approvalCheckCount.value >= _maxApprovalChecks) {
        _handleApprovalTimeout();
        return false;
      }

      _approvalCheckCount.value++;

      print('🔍 Checking approval status... (${_approvalCheckCount.value}/$_maxApprovalChecks)');

      try {
        final isApproved = await _registrationController.checkEmailApprovalStatus();

        if (isApproved) {
          _handleApprovalSuccess();
          return false;
        }

        return true;
      } catch (e) {
        print('❌ Approval check error: $e');
        return true;
      }
    });
  }

  void _handleRegistrationSuccess() {
    Get.snackbar(
      "রেজিস্ট্রেশন সফল! 🎉",
      "আপনার অ্যাকাউন্ট তৈরি হয়েছে। এখন লগইন করতে পারেন।",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/login');
    });
  }

  void _handleApprovalSuccess() {
    _isCheckingApproval.value = false;
    _registrationController.stopAutoApprovalCheck();

    print('🎉 Email approved! Registration confirmed.');

    Get.snackbar(
      "ইমেইল ভেরিফিকেশন সফল! ✅",
      "আপনার রেজিস্ট্রেশন সম্পূর্ণ হয়েছে। লগইন পেজে নিয়ে যাওয়া হচ্ছে...",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/login');
    });
  }

  void _handleApprovalTimeout() {
    _isCheckingApproval.value = false;
    _registrationController.stopAutoApprovalCheck();

    Get.snackbar(
      "সময় শেষ ⏰",
      "ইমেইল ভেরিফিকেশন সম্পন্ন হয়নি। দয়া করে ইমেইল চেক করে লিংকটি ক্লিক করুন এবং পরে লগইন করুন।",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );

    _showTimeoutDialog();
  }

  void _showTimeoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("ইমেইল ভেরিফিকেশন"),
        content: Text(
          "আপনার ইমেইল ভেরিফিকেশন এখনও সম্পন্ন হয়নি। আপনি কি লগইন পেজে যেতে চান?",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("আরও অপেক্ষা করুন"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/login');
            },
            child: Text("লগইন পেজে যান"),
          ),
        ],
      ),
    );
  }

  void _stopApprovalCheck() {
    _isCheckingApproval.value = false;
    _approvalCheckCount.value = 0;
  }

  void _demoSignUp() {
    _firstNameController.text = "জন";
    _lastNameController.text = "ডো";
    _usernameController.text = "johndoe";
    _emailController.text = "user@example.com";
    _phoneController.text = "01712345678";
    _passwordController.text = "password";
    _confirmPasswordController.text = "password";
    _agreeToTerms = true;

    Get.snackbar(
      "ডেমো ডেটা লোড হয়েছে",
      "এখন রেজিস্ট্রেশন বাটন ক্লিক করুন",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _navigateToLogin() {
    _stopApprovalCheck();
    _registrationController.stopAutoApprovalCheck();
    Get.back();
  }

  void _openEmailApp() {
    Get.snackbar(
      "ইমেইল চেক করুন",
      "আপনার ইমেইল অ্যাপ খুলুন এবং ভেরিফিকেশন লিংকটি ক্লিক করুন",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _manualApproveForTesting() {
    _registrationController.manuallyApproveEmail();
    _handleApprovalSuccess();
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
                Row(
                  children: [
                    IconButton(
                      onPressed: _navigateToLogin,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.textPrimary,
                      ),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: _manualApproveForTesting,
                      icon: Icon(Icons.check_circle, color: Colors.green),
                      tooltip: 'Manual Approve (Testing)',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 30),
                _buildSignUpForm(),
                const SizedBox(height: 20),
                _buildVerificationNotice(),
                const SizedBox(height: 16),
                Obx(
                  () => _isCheckingApproval.value || _registrationController.isWaitingForApproval.value
                      ? _buildApprovalStatus()
                      : const SizedBox(),
                ),
                _buildTermsCheckbox(),
                const SizedBox(height: 30),
                Obx(() => _buildSignUpButton()),
                const SizedBox(height: 20),
                _buildDemoButton(),
                const SizedBox(height: 30),
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

  Widget _buildApprovalStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.pending_actions, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              Text(
                "ইমেইল ভেরিফিকেশনের জন্য অপেক্ষা করুন",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: _approvalCheckCount.value / _maxApprovalChecks,
                  backgroundColor: Colors.orange.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade600),
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  "${_approvalCheckCount.value}/$_maxApprovalChecks",
                  style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "আপনার ইমেইল চেক করে লিংকটি ক্লিক করুন। অটোমেটিক রিডাইরেক্ট হবে।",
            style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openEmailApp,
                  icon: Icon(Icons.open_in_new, size: 16),
                  label: Text("ইমেইল অ্যাপ খুলুন"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange.shade700,
                    side: BorderSide(color: Colors.orange.shade400),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _navigateToLogin,
                  icon: Icon(Icons.login, size: 16),
                  label: Text("লগইন পেজে যান"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                    side: BorderSide(color: Colors.blue.shade400),
                  ),
                ),
              ),
            ],
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
            Text("আমি গ্রহণ করছি ", style: TextStyle(color: AppColors.textSecondary)),
            GestureDetector(
              onTap: () => Get.snackbar("সেবার শর্তাবলী", "শীঘ্রই আসছে", snackPosition: SnackPosition.BOTTOM),
              child: Text("সেবার শর্তাবলী", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            Text(" ও ", style: TextStyle(color: AppColors.textSecondary)),
            GestureDetector(
              onTap: () => Get.snackbar("গোপনীয়তা নীতি", "শীঘ্রই আসছে", snackPosition: SnackPosition.BOTTOM),
              child: Text("গোপনীয়তা নীতি", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildSignUpButton() {
    if (_isCheckingApproval.value || _registrationController.isWaitingForApproval.value) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Text("ভেরিফিকেশনের জন্য অপেক্ষা...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _registrationController.isLoading.value ? null : _signUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
        ),
        child: _registrationController.isLoading.value
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text("অ্যাকাউন্ট তৈরি করুন", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

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
      child: Text("ডেমো তথ্য ব্যবহার করুন (টেস্ট)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    ),
  );

  Widget _buildFooter() => Column(
    children: [
      Row(
        children: [
          Expanded(child: Divider()),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("অথবা", style: TextStyle(color: AppColors.textSecondary))),
          Expanded(child: Divider()),
        ],
      ),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _buildSocialButton(icon: Icons.g_mobiledata, onPressed: () => Get.snackbar("গুগল সাইন আপ", "শীঘ্রই আসছে")),
        SizedBox(width: 16),
        _buildSocialButton(icon: Icons.facebook, onPressed: () => Get.snackbar("ফেসবুক সাইন আপ", "শীঘ্রই আসছে")),
        SizedBox(width: 16),
        _buildSocialButton(icon: Icons.phone, onPressed: () => Get.snackbar("ফোন সাইন আপ", "শীঘ্রই আসছে")),
      ]),
      SizedBox(height: 30),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("ইতিমধ্যে অ্যাকাউন্ট আছে? "),
        GestureDetector(
          onTap: _navigateToLogin,
          child: Text("লগইন করুন", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
      ]),
    ],
  );

  Widget _buildSocialButton({required IconData icon, required VoidCallback onPressed}) => CircleAvatar(
    backgroundColor: AppColors.primaryLight.withOpacity(0.2),
    radius: 24,
    child: IconButton(onPressed: onPressed, icon: Icon(icon, color: AppColors.primary)),
  );
}