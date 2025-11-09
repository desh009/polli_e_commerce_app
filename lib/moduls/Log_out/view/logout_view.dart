// moduls/Log_out/view/log_out_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/moduls/Log_out/controller/log_out_controller.dart';

class LogoutView extends GetView<LogoutController> {
  const LogoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("লগআউট"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.red.shade700,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout,
                  size: 60,
                  color: Colors.red.shade700,
                ),
              ),
              
              SizedBox(height: 30),
              
              // Title
              Text(
                "অ্যাকাউন্ট থেকে লগআউট",
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              
              SizedBox(height: 15),
              
              // Description
              Text(
                "আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?\nলগআউট করলে আপনার কার্ট এবং অন্যান্য ডেটা মুছে যাবে।",
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 40),
              
              // Logout Button
              Obx(() {
                if (controller.isLoggingOut.value) {
                  return Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade700),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "লগআউট করা হচ্ছে...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  );
                }
                
                return Column(
                  children: [
                    // Confirm Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: controller.logout,
                        icon: Icon(Icons.logout, size: 24),
                        label: Text(
                          "হ্যাঁ, লগআউট করুন",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 15),
                    
                    // Cancel Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          "বাতিল করুন",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              
              SizedBox(height: 30),
              
              // Additional Info
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "লগআউট করলে আপনার ব্যক্তিগত তথ্য সুরক্ষিত থাকবে। প্রয়োজন时 পুনরায় লগইন করতে পারবেন।",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}