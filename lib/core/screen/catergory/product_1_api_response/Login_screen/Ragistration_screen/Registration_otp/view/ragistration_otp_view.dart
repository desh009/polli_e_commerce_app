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
  final RegistrationController _registrationController = Get.find<RegistrationController>();

  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _resendTimer = 60;
  bool _canResend = false;
  bool _isVerifying = false;
  bool _localLoading = false;
  bool _isMounted = false;
  Timer? _resendTimerController;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    print('🎯 OTP Screen INIT for email: ${widget.email}');
    
    _startResendTimer();
    _setupFocusListeners();
    
    ever(_registrationController.isVerificationSuccess, (isSuccess) {
      if (_isMounted && isSuccess == true) {
        print('✅ OTP Verification Success - Navigation should happen');
      }
    });
  }

  void _setupFocusListeners() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_isMounted && _focusNodes[i].hasFocus && _otpControllers[i].text.isNotEmpty) {
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
      if (!_isMounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _onOtpChanged(String value, int index) {
    if (!_isMounted) return;

    if (value.isNotEmpty && !RegExp(r'^[0-9]$').hasMatch(value)) {
      _otpControllers[index].clear();
      return;
    }
    
    if (value.length > 1) {
      _otpControllers[index].text = value[0];
    }

    if (value.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    if (_isOtpComplete() && index == 5) {
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
    if (_isVerifying || !_isMounted || !_isOtpComplete()) return;

    final otp = _getOtp();
    
    setState(() {
      _isVerifying = true;
      _localLoading = true;
    });

    try {
      print('🔐 Verifying OTP: $otp for email: ${widget.email}');
      await _registrationController.verifyOtpAndCompleteRegistration(otp);
    } catch (e) {
      print('❌ OTP Verification error: $e');
      if (_isMounted) {
        _clearOtpFields();
        setState(() {
          _isVerifying = false;
          _localLoading = false;
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
    if (_isMounted) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }
  }

  void _showExitConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text("ইমেইল ভেরিফিকেশন"),
        content: const Text("আপনি কি ভেরিফিকেশন বাতিল করতে চান? আপনার রেজিস্ট্রেশন সম্পূর্ণ হবে না।"),
        actions: [
          TextButton(
            onPressed: () => Get.back(), 
            child: const Text("রয়ে যান")
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text("বাতিল করুন", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool get _isLoading => _localLoading || _isVerifying;

  @override
  void dispose() {
    print('🗑️ OTP Screen DISPOSE');
    _isMounted = false;
    
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    
    _resendTimerController?.cancel();
    
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView( // ✅ Added SingleChildScrollView
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48, // Account for padding
                ),
                child: IntrinsicHeight( // ✅ Added IntrinsicHeight
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: 40),
                      _buildOtpInputSection(),
                      const SizedBox(height: 30),
                      _buildVerifyButton(),
                      const SizedBox(height: 20),
                      // _buildResendSection(),
                      const Spacer(),
                      _buildHelpSection(),
                    ],
                  ),
                ),
              ),
            );
          },
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
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
            children: [
              const TextSpan(text: 'আমরা একটি ৬-ডিজিটের কোড পাঠিয়েছি '),
              TextSpan(
                text: widget.email,
                style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
              const TextSpan(text: ' এ'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'এই কোডটি আপনার অ্যাকাউন্ট ভেরিফাই করবে',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.5)),
                  ),
                  filled: true,
                  fillColor: _focusNodes[index].hasFocus ? AppColors.primary.withOpacity(0.1) : Colors.grey[50],
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
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildHelpSection() {
    return Container( // ✅ Wrapped in Container for better spacing
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
            const SizedBox(height: 8),
            Text(
              '২৪/৭ সেবা পাওয়া যাবে',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}