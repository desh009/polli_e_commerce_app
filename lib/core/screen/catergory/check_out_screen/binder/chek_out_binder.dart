// lib/core/screen/check_out_screen/binding/chek_out_binder.dart
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/controller/chek_out_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/repository/chek_out_repository.dart';

class CheckoutBinding implements Bindings {
  @override
  void dependencies() {
    // ✅ Repository register করুন
    Get.lazyPut<CheckoutRepository>(
      () => CheckoutRepository(
        networkClient: Get.find(), // আপনার NetworkClient
      ),
    );

    // ✅ Controller register করুন - সঠিক dependency সহ
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(
        checkoutRepository: Get.find<CheckoutRepository>(),
        cartController: Get.find<CartController>(),
      ),
    );
  }
}
