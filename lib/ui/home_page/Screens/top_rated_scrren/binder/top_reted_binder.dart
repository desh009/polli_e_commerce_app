// lib/core/binder/features/top_rated_binder.dart
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/ui/home_page/Screens/top_rated_scrren/controler/top_rated_controler.dart';

class TopRatedBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TopRatedController>(
      () => TopRatedController(),
      fenix: true,
    );
  }
}