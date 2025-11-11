// lib/core/binder/favourite_binder.dart
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/ui/home_page/Screens/favourite_pages/controller/favourite_page_controller.dart' show FavouriteController;

class FavouriteBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavouriteController>(
      () => FavouriteController(),
      fenix: true,
    );
  }
}