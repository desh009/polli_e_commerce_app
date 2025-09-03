import 'package:get/get.dart';
import 'package:polli_e_commerce_app/moduls/profile/profile_controller/profile.controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
