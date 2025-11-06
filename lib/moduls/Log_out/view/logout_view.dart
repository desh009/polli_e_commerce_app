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
        title: const Text("Logout"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 80, color: Colors.red),
              SizedBox(height: 20),
              Text(
                "Logout from Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Are you sure you want to logout?",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Obx(() {
                return controller.isLoggingOut.value
                    ? Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text("Logging out..."),
                        ],
                      )
                    : Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: controller.logout,
                            icon: Icon(Icons.logout),
                            label: Text("Confirm Logout"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text("Cancel"),
                          ),
                        ],
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
