import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/routes/app_pages.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String email;
  final String phone;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    // Auto navigate after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToCart();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text("OTP Verification Successful!"),
              const SizedBox(height: 10),
              Text("Redirecting to cart..."),
              const SizedBox(height: 10),
              Text("Email: $email"),
              Text("Phone: $phone"),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCart() {
    Future.delayed(const Duration(seconds: 1), () {
      Get.offAllNamed(
        Routes.CART,
        arguments: {
          'email': email,
          'phone': phone,
          'verified': true,
        },
      );
    });
  }
}
