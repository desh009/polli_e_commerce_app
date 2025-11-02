import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/cart_item/cart_item.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void addToCart(CartItem item) {
    final existingItem =
        cartItems.firstWhereOrNull((element) => element.id == item.id);

    if (existingItem != null) {
      existingItem.quantity += item.quantity;
      cartItems.refresh();
    } else {
      cartItems.add(item);
    }
  }

  void updateQuantity(int id, int newQuantity) {
    final item = cartItems.firstWhereOrNull((e) => e.id == id);
    if (item != null) {
      if (newQuantity <= 0) {
        cartItems.remove(item);
      } else {
        item.quantity = newQuantity;
        cartItems.refresh();
      }
    }
  }

  void clearCart() {
    cartItems.clear();
  }
}