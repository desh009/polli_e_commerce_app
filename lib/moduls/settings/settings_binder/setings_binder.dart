import 'package:get/get.dart';
import 'package:polli_e_commerce_app/moduls/settings/settings_controller/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
