// login_auth_binding/login_auth_binding.dart
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/controller/registration_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/controller/login_controller.dart';

class EpicAuthBinding extends Bindings {
  @override
  void dependencies() {
    print('🔐 Initializing Auth Bindings...');

    // ✅ RegistrationController add করুন
    Get.lazyPut<RegistrationController>(
      () => RegistrationController(),
      fenix: true,
    );
    print('✅ RegistrationController bound');

    // Existing auth controller
    Get.lazyPut<EpicAuthController>(() => EpicAuthController(), fenix: true);
    print('✅ EpicAuthController bound');

    print('🎉 All Auth Bindings Initialized!');
  }
}
