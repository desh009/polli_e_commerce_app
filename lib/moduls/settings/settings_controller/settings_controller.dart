import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Notification on/off
  var notifications = true.obs;

  // Dark Mode on/off
  var darkMode = false.obs;

  // Language (default English)
  var language = "English".obs;

  void toggleNotifications(bool value) {
    notifications.value = value;
  }

  void toggleDarkMode(bool value) {
    darkMode.value = value;
  }

  void changeLanguage(String lang) {
    language.value = lang;
  }
}
