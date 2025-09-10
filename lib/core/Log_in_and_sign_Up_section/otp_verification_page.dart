import 'package:flutter/material.dart';

class OtpVerificationPage extends StatefulWidget {
  final String mobileNumber; // OTP kiser jonno pathano hocche

  const OtpVerificationPage({super.key, required this.mobileNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      // ekhane OTP API call korte hobe
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Verified Successfully!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text("Welcome! OTP Verified Successfully")),
          ),
        ),
      );
    }
  }

  void _resendOtp() {
    // ekhane resend OTP API call korte hobe
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP Resent Successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Enter the OTP sent to ${widget.mobileNumber}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // OTP Field
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "OTP",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter OTP";
                  }
                  if (value.length != 6) {
                    return "OTP must be 6 digits";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Verify Button
              ElevatedButton(
                onPressed: _verifyOtp,
                child: const Text("Verify OTP"),
              ),
              const SizedBox(height: 10),

              // Resend OTP
              TextButton(
                onPressed: _resendOtp,
                child: const Text("Resend OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
