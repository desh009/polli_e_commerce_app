import 'package:get/get.dart';
import 'package:polli_e_commerce_app/moduls/Log_out/controller/log_out_controller.dart';

class LogoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogoutController>(() => LogoutController());
  }
}

