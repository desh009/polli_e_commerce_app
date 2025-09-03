import 'dart:async';
import 'package:flutter/material.dart';
import 'package:polli_e_commerce_app/ui/home_page/view/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, // ব্যাকগ্রাউন্ড কালার গ্রিন
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/images/Screenshot_34.png', // তোমার লোগো ফাইল
            //   width: 150, // ছোট সাইজ
            //   height: 150,
            //   fit: BoxFit.contain,
            // ),
             SizedBox(height: 20),
            const Text(
              "পল্লী স্বাদ",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              "গ্রামের খাঁটি স্বাদ",
              style: TextStyle(fontSize: 40, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
