// lib/core/binder/features/delivery_info_binder.dart
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/ui/home_page/Screens/delivery/controller/delivery_controler.dart';

class DeliveryInfoBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryInfoController>(
      () => DeliveryInfoController(),
      fenix: true,
    );
  }
}