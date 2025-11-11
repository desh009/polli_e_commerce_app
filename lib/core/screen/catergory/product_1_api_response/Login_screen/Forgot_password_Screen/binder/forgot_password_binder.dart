// lib/core/binder/auth/forgot_password_binder.dart
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Forgot_password_Screen/controller/forot_password_controller.dart';

class ForgotPasswordBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
      fenix: true,
    );
  }
}