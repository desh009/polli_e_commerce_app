// lib/core/binder/features/customer_support_binder.dart
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/ui/home_page/Screens/customer_suppport/controler/customer_suppport_controller.dart';

class CustomerSupportBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerSupportController>(
      () => CustomerSupportController(),
      fenix: true,
    );
  }
}