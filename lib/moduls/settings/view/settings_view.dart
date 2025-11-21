// settings_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/moduls/settings/settings_controller/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 🔔 Notifications
            _buildNotificationTile(),
            const Divider(),

            // 🌙 Dark Mode
            _buildDarkModeTile(),
            const Divider(),

            // 🌍 Language
            _buildLanguageTile(),
            const Divider(),

            // ❌ Logout
            _buildLogoutTile(),
          ],
        );
      }),
    );
  }

  Widget _buildNotificationTile() {
    return SwitchListTile(
      title: const Text(
        "Enable Notifications",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: const Text("অ্যাপ নোটিফিকেশন চালু করুন"),
      value: controller.notifications.value,
      onChanged: controller.toggleNotifications,
      secondary: Icon(
        Icons.notifications,
        color: Get.theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildDarkModeTile() {
    return SwitchListTile(
      title: const Text(
        "Dark Mode",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        controller.darkMode.value ? "ডার্ক মোড চালু" : "ডার্ক মোড বন্ধ",
      ),
      value: controller.darkMode.value,
      onChanged: controller.toggleDarkMode,
      secondary: Icon(
        controller.darkMode.value ? Icons.dark_mode : Icons.light_mode,
        color: Get.theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildLanguageTile() {
    return ListTile(
      leading: Icon(
        Icons.language,
        color: Get.theme.colorScheme.primary,
      ),
      title: const Text(
        "Language",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(controller.language.value),
      trailing: PopupMenuButton<String>(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Get.theme.colorScheme.primary,
        ),
        onSelected: controller.changeLanguage,
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: "English",
            child: Row(
              children: [
                Icon(Icons.language, size: 20),
                SizedBox(width: 8),
                Text("English"),
              ],
            ),
          ),
          const PopupMenuItem(
            value: "বাংলা",
            child: Row(
              children: [
                Icon(Icons.language, size: 20),
                SizedBox(width: 8),
                Text("বাংলা"),
              ],
            ),
          ),
          const PopupMenuItem(
            value: "हिन्दी",
            child: Row(
              children: [
                Icon(Icons.language, size: 20),
                SizedBox(width: 8),
                Text("हिन्दी"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        "Logout",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
      ),
      subtitle: const Text("অ্যাপ থেকে লগআউট করুন"),
      onTap: _showLogoutDialog,
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("লগআউট"),
        content: const Text("আপনি কি নিশ্চিতভাবে লগআউট করতে চান?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("বাতিল"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                "লগআউট সফল",
                "আপনি সফলভাবে লগআউট করেছেন",
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
              // Add your logout logic here
              // Get.offAllNamed('/login');
            },
            child: const Text(
              "লগআউট",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}