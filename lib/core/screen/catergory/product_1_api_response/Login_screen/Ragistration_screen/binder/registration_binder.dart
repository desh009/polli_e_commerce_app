// lib/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/binder/registration_binder.dart

import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/controller/registration_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/repository/registration_repository.dart';

class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    print('🔐 Initializing Registration Bindings...');
    
    // ✅ CORRECT - positional argument
    Get.lazyPut<RegistrationRepository>(
      () => RegistrationRepository(Get.find<NetworkClient>(), networkClient: Get.find<NetworkClient>()),
      fenix: true,
    );
    print('✅ RegistrationRepository bound');

    // ✅ CORRECT - positional argument
    Get.lazyPut<RegistrationController>(
      () => RegistrationController(Get.find<RegistrationRepository>()),
      fenix: true,
    );
    print('✅ RegistrationController bound');
    
    print('🎉 Registration Bindings Initialized!');
  }
}