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
            SwitchListTile(
              title: const Text("Enable Notifications"),
              value: controller.notifications.value,
              onChanged: controller.toggleNotifications,
              secondary: const Icon(Icons.notifications),
            ),
            const Divider(),

            // 🌙 Dark Mode
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: controller.darkMode.value,
              onChanged: controller.toggleDarkMode,
              secondary: const Icon(Icons.dark_mode),
            ),
            const Divider(),

            // 🌍 Language
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Language"),
              subtitle: Text(controller.language.value),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down),
                onSelected: (val) => controller.changeLanguage(val),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: "English", child: Text("English")),
                  const PopupMenuItem(value: "বাংলা", child: Text("বাংলা")),
                  const PopupMenuItem(value: "हिन्दी", child: Text("हिन्दी")),
                ],
              ),
            ),
            const Divider(),

            // ❌ Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                Get.snackbar("Logout", "You have been logged out.");
              },
            ),
          ],
        );
      }),
    );
  }
}
