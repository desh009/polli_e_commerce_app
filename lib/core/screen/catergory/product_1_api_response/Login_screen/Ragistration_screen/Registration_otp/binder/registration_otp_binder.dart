import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/Registration_otp/controller/registration_otp_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/Registration_otp/repository/registration_otp_repo.dart';

class UserZxBinding implements Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<UserZxRepository>(() => UserZxRepository(), fenix: true);

    // Controller
    Get.lazyPut<UserZxController>(() => UserZxController(), fenix: true);
  }
}