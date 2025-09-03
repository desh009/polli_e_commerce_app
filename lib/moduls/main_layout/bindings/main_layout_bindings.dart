import 'package:get/get.dart';
import 'package:polli_e_commerce_app/moduls/main_layout/controller/main_layout_controller.dart';


class MainLayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainLayoutController>(
      () => MainLayoutController(),
    );
  }
}
