import 'package:get/get.dart';
import 'package:polli_e_commerce_app/moduls/my_order/controller/my_order_controler.dart';

class MyOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyOrderController>(() => MyOrderController());
  }
}
