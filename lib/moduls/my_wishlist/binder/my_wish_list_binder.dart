import 'package:get/get.dart';
import 'package:polli_e_commerce_app/moduls/my_wishlist/controller/my_wish_list_contoller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WishlistController>(() => WishlistController());
  }
}
