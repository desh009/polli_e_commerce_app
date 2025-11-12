import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/controller/registration_controller.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final RegistrationController _registrationController = Get.find<RegistrationController>();
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _resendTimer = 60;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus && _otpControllers[i].text.isNotEmpty) {
          _otpControllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _otpControllers[i].text.length,
          );
        }
      });
    }
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
            _startResendTimer();
          } else {
            _canResend = true;
          }
        });
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    // Allow only numeric input and limit to 1 character
    if (value.isNotEmpty) {
      if (!RegExp(r'^[0-9]$').hasMatch(value)) {
        _otpControllers[index].clear();
        return;
      }
      if (value.length > 1) {
        _otpControllers[index].text = value[0];
      }
    }

    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Auto verify when all fields are filled
    if (_isOtpComplete() && index == 5) {
      _verifyOtp();
    }
  }

  bool _isOtpComplete() {
    for (var controller in _otpControllers) {
      if (controller.text.isEmpty) return false;
    }
    return true;
  }

  String _getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    if (_isVerifying) return;
    
    final otp = _getOtp();
    if (otp.length == 6) {
      setState(() {
        _isVerifying = true;
      });
      
      try {
        await _registrationController.verifyOtpAndCompleteRegistration(otp);
        // Success navigation handled in controller
      } catch (e) {
        // Error handled in controller, clear fields for retry
        _clearOtpFields();
      } finally {
        if (mounted) {
          setState(() {
            _isVerifying = false;
          });
        }
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_canResend && !_isVerifying) {
      try {
        await _registrationController.resendOtp();
        
        setState(() {
          _resendTimer = 60;
          _canResend = false;
          _clearOtpFields();
        });
        _startResendTimer();

        Get.snackbar(
          'OTP পাঠানো হয়েছে ✅',
          'নতুন OTP ${widget.email} নম্বরে পাঠানো হয়েছে',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } catch (e) {
        Get.snackbar(
          'ত্রুটি ❌',
          'OTP পাঠানো যায়নি: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  void _clearOtpFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _showExitConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text("OTP ভেরিফিকেশন"),
        content: const Text("আপনি কি OTP ভেরিফিকেশন বাতিল করতে চান? আপনার রেজিস্ট্রেশন সম্পূর্ণ হবে না।"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("রয়ে যান"),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Navigate back
            },
            child: const Text("বাতিল করুন", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool get _isLoading => _registrationController.isLoading.value || _isVerifying;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: _showExitConfirmation,
        ),
        title: Text(
          'ফোন নম্বর ভেরিফিকেশন',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(),
              const SizedBox(height: 40),

              // OTP Input Fields
              _buildOtpInputSection(),
              const SizedBox(height: 30),

              // Verify Button
              _buildVerifyButton(),
              const SizedBox(height: 20),

              // Resend OTP Section
              _buildResendSection(),
              const Spacer(),

              // Help Text
              _buildHelpSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OTP ভেরিফিকেশন',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'আমরা একটি ৬-ডিজিটের কোড পাঠিয়েছি '),
              TextSpan(
                text: widget.email,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const TextSpan(text: ' নম্বরে'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'এই কোডটি আপনার অ্যাকাউন্ট ভেরিফাই করবে',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInputSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 50,
              height: 60,
              child: TextFormField(
                controller: _otpControllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.5)),
                  ),
                  filled: true,
                  fillColor: _focusNodes[index].hasFocus 
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.grey[50],
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) => _onOtpChanged(value, index),
                onTap: () {
                  _otpControllers[index].selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _otpControllers[index].text.length,
                  );
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Text(
          '৬-ডিজিটের OTP লিখুন',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (_isOtpComplete() && !_isLoading) ? _verifyOtp : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
        ),
        child: _isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'ভেরিফাই করুন',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: Column(
        children: [
          Text(
            'কোড পাননি?',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _canResend && !_isLoading ? _resendOtp : null,
            child: Text(
              _canResend ? 'আবার OTP পাঠান' : '${_resendTimer} সেকেন্ড পরে আবার চেষ্টা করুন',
              style: TextStyle(
                color: _canResend && !_isLoading 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    return Center(
      child: Column(
        children: [
          Text(
            'সমস্যা হচ্ছে?',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'হেল্পলাইন: ১৬৩৪৫',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '২৪/৭ সেবা পাওয়া যাবে',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}