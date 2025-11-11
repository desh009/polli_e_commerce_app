// lib/core/binder/features/authentic_products_binder.dart
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/ui/home_page/Screens/Authentic/controller/authentic_controller.dart';

class AuthenticProductsBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthenticProductsController>(
      () => AuthenticProductsController(),
      fenix: true,
    );
  }
}