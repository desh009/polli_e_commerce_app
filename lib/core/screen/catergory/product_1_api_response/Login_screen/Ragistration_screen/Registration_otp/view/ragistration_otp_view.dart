import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/controller/registration_controller.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final RegistrationController _registrationController;
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _resendTimer = 60;
  bool _canResend = false;
  bool _isVerifying = false;
  Timer? _resendTimerController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    print('🎯 OTP Screen INIT for email: ${widget.email}');
    
    // ✅ FIXED: Initialize controller
    _registrationController = Get.find<RegistrationController>();
    
    _startResendTimer();
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_isDisposed || !mounted) return;
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
    _resendTimerController?.cancel();
    _resendTimerController = Timer.periodic(const Duration(seconds: 1), (timer) {
      // ✅ FIXED: Double check before setState
      if (_isDisposed || !mounted) {
        timer.cancel();
        return;
      }

      // ✅ FIXED: Safe state update
      if (mounted && !_isDisposed) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    // ✅ FIXED: Early return if disposed
    if (_isDisposed || !mounted) return;

    // Handle paste or multiple characters
    final numbersOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numbersOnly.isNotEmpty && numbersOnly.length > 1) {
      // Auto-fill OTP fields for paste
      for (int i = 0; i < numbersOnly.length && i < 6; i++) {
        final currentIndex = index + i;
        if (currentIndex < 6 && mounted && !_isDisposed) {
          _otpControllers[currentIndex].text = numbersOnly[i];
          if (currentIndex < 5) {
            FocusScope.of(context).requestFocus(_focusNodes[currentIndex + 1]);
          }
        }
      }
      // Auto verify if complete
      if (_isOtpComplete() && mounted && !_isDisposed) {
        _verifyOtp();
      }
      return;
    }

    // Single character input
    if (value.isNotEmpty && !RegExp(r'^[0-9]$').hasMatch(value)) {
      _otpControllers[index].clear();
      return;
    }

    if (value.length == 1 && index < 5 && mounted && !_isDisposed) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0 && mounted && !_isDisposed) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    // Auto verify when all fields are filled
    if (_isOtpComplete() && index == 5 && mounted && !_isDisposed) {
      _verifyOtp();
    }
  }

  bool _isOtpComplete() {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  String _getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    // ✅ FIXED: Multiple checks before proceeding
    if (_isVerifying || !_isOtpComplete() || _isDisposed || !mounted) return;

    final otp = _getOtp();

    // ✅ FIXED: Safe state update
    if (!mounted || _isDisposed) return;
    
    setState(() {
      _isVerifying = true;
    });

    try {
      print('🔐 Verifying OTP: $otp for email: ${widget.email}');
      
      await _registrationController.verifyOtpAndCompleteRegistration(otp);
      
      // Success navigation handled by controller
      
    } catch (e) {
      print('❌ OTP Verification error: $e');
      
      // ✅ FIXED: Safe state update with check
      if (mounted && !_isDisposed) {
        _clearOtpFields();
        setState(() {
          _isVerifying = false;
        });

        Get.snackbar(
          'ভেরিফিকেশন ব্যর্থ ❌',
          'দয়া করে সঠিক OTP দিন',
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
    if (mounted && !_isDisposed) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }
  }

  void _resendOtp() {
    if (!_canResend || _isDisposed || !mounted) return;

    setState(() {
      _resendTimer = 60;
      _canResend = false;
    });

    _startResendTimer();

    // TODO: Implement resend OTP API call
    if (!_isDisposed && mounted) {
      Get.snackbar(
        'OTP পুনরায় পাঠানো হয়েছে',
        'আপনার ইমেইলে নতুন OTP পাঠানো হয়েছে',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _showExitConfirmation() {
    if (_isDisposed || !mounted) return;
    
    Get.dialog(
      AlertDialog(
        title: const Text("ইমেইল ভেরিফিকেশন"),
        content: const Text(
          "আপনি কি ভেরিফিকেশন বাতিল করতে চান? আপনার রেজিস্ট্রেশন সম্পূর্ণ হবে না।",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("রয়ে যান"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              if (!_isDisposed && mounted) {
                Get.back();
              }
            },
            child: const Text(
              "বাতিল করুন",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    print('🗑️ OTP Screen DISPOSE');
    
    // ✅ FIXED: Mark as disposed first
    _isDisposed = true;
    
    // ✅ FIXED: Cancel timer and nullify
    _resendTimerController?.cancel();
    _resendTimerController = null;

    // ✅ FIXED: Dispose all controllers
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    
    // ✅ FIXED: Dispose all focus nodes
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
          'ইমেইল ভেরিফিকেশন',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 40),
              _buildOtpInputSection(),
              const SizedBox(height: 20),
              _buildResendButton(),
              const SizedBox(height: 30),
              _buildVerifyButton(),
              const SizedBox(height: 40),
              _buildHelpSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ... (বাকি UI methods একই থাকবে)
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
              const TextSpan(text: ' এ'),
            ],
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
                textInputAction: index == 5 ? TextInputAction.done : TextInputAction.next,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.textSecondary.withOpacity(0.3),
                    ),
                  ),
                  filled: true,
                  fillColor: _focusNodes[index].hasFocus
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.grey[50],
                ),
                onChanged: (value) => _onOtpChanged(value, index),
                onTap: () {
                  if (!_isDisposed && mounted) {
                    _otpControllers[index].selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _otpControllers[index].text.length,
                    );
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Text(
          '৬-ডিজিটের OTP লিখুন',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildResendButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'কোড পাননি?',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _canResend ? _resendOtp : null,
          child: Text(
            _canResend ? 'কোড পুনরায় পাঠান' : '$_resendTimer সেকেন্ড অপেক্ষা করুন',
            style: TextStyle(
              color: _canResend ? AppColors.primary : Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (_isOtpComplete() && !_isVerifying && !_isDisposed) ? _verifyOtp : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isVerifying
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildHelpSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Center(
        child: Column(
          children: [
            Text(
              'সমস্যা হচ্ছে?',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
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
          ],
        ),
      ),
    );
  }
}