import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/cart_item/cart_item.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void addToCart(CartItem item) {
    // যদি একই product আগে থেকে থাকে, quantity বাড়াও
    int index = cartItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      cartItems[index].quantity += item.quantity;
      cartItems.refresh();
    } else {
      cartItems.add(item);
    }
  }

  void removeFromCart(CartItem item) {
    cartItems.remove(item);
  }

  double get subtotal =>
      cartItems.fold(0, (sum, i) => sum + i.price * i.quantity);

  double get deliveryCharge => cartItems.isEmpty ? 0 : 135;

  double get grandTotal => subtotal + deliveryCharge;

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
