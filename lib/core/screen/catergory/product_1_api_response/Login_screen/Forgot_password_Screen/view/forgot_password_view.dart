// lib/core/screen/auth/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Forgot_password_Screen/controller/forot_password_controller.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // ✅ FIXED: Use Get.put()
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      controller.email.value = _emailController.text;
      controller.clearError();
    });
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      // Real API call
      controller.resetPassword();
      
      // For testing only - comment out when using real API
      // controller.demoResetPassword();
    }
  }

  void _demoFill() {
    controller.demoFill();
    _emailController.text = controller.email.value;
  }

  void _handleBackButton() {
    if (Navigator.canPop(Get.context!)) {
      Get.back();
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
                  onPressed: _handleBackButton,
                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                const SizedBox(height: 20),
                
                // Header Section
                _buildHeader(),
                const SizedBox(height: 40),
                
                // Email Form
                _buildEmailForm(),
                const SizedBox(height: 30),
                
                // Error Message
                _buildErrorMessage(),
                
                // Reset Button
                _buildResetButton(),
                const SizedBox(height: 20),
                
                // Demo Button (Optional)
                _buildDemoButton(),
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
          "পাসওয়ার্ড ভুলে গেছেন?",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "আপনার ইমেইল এড্রেস লিখুন, আমরা আপনাকে পাসওয়ার্ড রিসেট লিঙ্ক পাঠাবো",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ইমেইল এড্রেস",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "আপনার ইমেইল এড্রেস লিখুন",
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.primaryLight.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: controller.validateEmail,
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Obx(() => controller.errorMessage.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink());
  }

  Widget _buildResetButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : _resetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                "পাসওয়ার্ড রিসেট লিঙ্ক পাঠান",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ));
  }

  Widget _buildDemoButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: _demoFill,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "ডেমো ইমেইল ব্যবহার করুন",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}