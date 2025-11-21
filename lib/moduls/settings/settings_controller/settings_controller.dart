// settings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final RxBool notifications = true.obs;
  final RxBool darkMode = false.obs;
  final RxString language = "English".obs;

  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  // ✅ Load saved settings
  void _loadSettings() {
    try {
      // Load dark mode setting
      darkMode.value = _box.read('darkMode') ?? false;
      
      // Load other settings
      notifications.value = _box.read('notifications') ?? true;
      language.value = _box.read('language') ?? "English";
      
      print('📱 Settings loaded - Dark Mode: ${darkMode.value}');
    } catch (e) {
      print('❌ Error loading settings: $e');
    }
  }

  // ✅ Toggle Dark Mode
  void toggleDarkMode(bool value) {
    try {
      darkMode.value = value;
      
      // Save to GetStorage
      _box.write('darkMode', value);
      
      // Apply theme immediately
      Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
      
      Get.snackbar(
        value ? "Dark Mode On" : "Dark Mode Off",
        value ? "ডার্ক মোড চালু হয়েছে" : "ডার্ক মোড বন্ধ হয়েছে",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: value ? Colors.grey[900] : Colors.white,
        colorText: value ? Colors.white : Colors.black,
      );
      
      print('🌙 Dark Mode: $value');
    } catch (e) {
      print('❌ Error toggling dark mode: $e');
    }
  }

  // ✅ Toggle Notifications
  void toggleNotifications(bool value) {
    notifications.value = value;
    _box.write('notifications', value);
  }

  // ✅ Change Language
  void changeLanguage(String value) {
    language.value = value;
    _box.write('language', value);
    
    Get.snackbar(
      "Language Changed",
      "ভাষা পরিবর্তন হয়েছে: $value",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}