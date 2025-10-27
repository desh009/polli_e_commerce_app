// lib/core/screen/check_out_screen/binding/chek_out_binder.dart
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/check_out_screen/controller/chek_out_controller.dart';
import 'package:polli_e_commerce_app/core/screen/check_out_screen/repository/chek_out_repository.dart';

class CheckoutBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderRepository>(() => OrderRepository());
    Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}