import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  void addToCart(CartItem item) {
    // check if item already exists
    final index = cartItems.indexWhere((e) => e.id == item.id);
    if (index >= 0) {
      cartItems[index].quantity += item.quantity;
    } else {
      cartItems.add(item);
    }
  }

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.totalPrice);

 // CartController.dart
void updateQuantity(int id, int newQty) {
  final index = cartItems.indexWhere((e) => e.id == id);
  if (index >= 0) {
    cartItems[index].quantity = newQty;
    if (cartItems[index].quantity <= 0) cartItems.removeAt(index);
  }
}


  void clearCart() {
    cartItems.clear();
  }
}

// CartItem model
class CartItem {
  final int id;
  final String name;
  final String category;
  final String imagePath;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.price,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}
