// lib/core/bindings/profile_binding.dart
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/Screens/profile_screen/controller/profile_update_screen_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    // ProfileController register করুন
    Get.lazyPut<ProfileXController>(
      () => ProfileXController(),
      tag: 'profile', // Optional tag দিয়ে আলাদা করতে পারেন
      fenix: true, // Screen close/open করলে reuse হবে
    );
    
    print('✅ ProfileBinding initialized');
  }
}