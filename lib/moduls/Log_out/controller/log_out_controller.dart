import 'package:get/get.dart';

class LogoutController extends GetxController {
  var isLoggingOut = false.obs;

  Future<void> logout() async {
    isLoggingOut.value = true;

    await Future.delayed(const Duration(seconds: 2)); // API call এর simulation

    isLoggingOut.value = false;

    // Logout সফল হলে
    Get.snackbar("Logout", "You have been logged out successfully.");

    // এখানে চাইলে storage clear করে login page এ পাঠানো যাবে
    // await Get.offAllNamed('/login');
  }
}
