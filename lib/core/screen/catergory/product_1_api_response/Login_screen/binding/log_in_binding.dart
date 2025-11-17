// lib/core/screen/catergory/product_1_api_response/Login_screen/binder/login_binder.dart
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/controller/login_controller.dart';

class LoginBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EpicAuthController>(
      () => EpicAuthController(),
      fenix: true,
    );
    print('✅ LoginBinder initialized - EpicAuthController loaded');
  }
}
