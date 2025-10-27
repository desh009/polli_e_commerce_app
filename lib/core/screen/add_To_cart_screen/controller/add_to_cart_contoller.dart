import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var totalPrice = 0.0.obs;
  var totalItems = 0.obs;

  void addToCart(CartItem item) {
    final index = cartItems.indexWhere((e) => e.id == item.id);
    if (index >= 0) {
      cartItems[index].quantity += item.quantity;
    } else {
      cartItems.add(item);
    }
    _calculateTotals();
  }

  void updateQuantity(int id, int newQty) {
    final index = cartItems.indexWhere((e) => e.id == id);
    if (index >= 0) {
      if (newQty <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index].quantity = newQty;
      }
      _calculateTotals();
      cartItems.refresh(); // এই লাইনটি খুবই গুরুত্বপূর্ণ
    }
  }

  void removeFromCart(int id) {
    cartItems.removeWhere((item) => item.id == id);
    _calculateTotals();
  }

  void clearCart() {
    cartItems.clear();
    _calculateTotals();
  }

  void _calculateTotals() {
    totalItems.value = cartItems.fold(0, (sum, item) => sum + item.quantity);
    totalPrice.value = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
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
    this.quantity = 1, required int discount,
  });

  double get totalPrice => price * quantity;

  // copyWith মেথড যোগ করুন (যদি প্রয়োজন হয়)
  CartItem copyWith({
    int? id,
    String? name,
    String? category,
    String? imagePath,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity, discount: 0,
    );
  }
}