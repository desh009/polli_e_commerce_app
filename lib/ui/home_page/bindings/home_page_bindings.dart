import 'package:get/get.dart';
import 'package:polli_e_commerce_app/ui/home_page/controller/home_page_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
