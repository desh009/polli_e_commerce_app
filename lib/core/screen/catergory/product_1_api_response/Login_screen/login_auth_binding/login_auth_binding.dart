import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/repository/login_repository.dart';

class EpicAuthBinding implements Bindings {
  @override
  void dependencies() {
    print('🔧 ========== EPIC AUTH BINDING INITIALIZED ==========');
    
    // NetworkClient should already be registered in main.dart
    final networkClient = Get.find<NetworkClient>();
    
    // Register Auth Repository
    Get.lazyPut<EpicAuthRepository>(
      () => EpicAuthRepository(networkClient: networkClient),
      fenix: true,
    );
    
    print('✅ EpicAuthRepository registered in binding');
    print('✅ EpicAuthController already registered in main.dart');
  }
}