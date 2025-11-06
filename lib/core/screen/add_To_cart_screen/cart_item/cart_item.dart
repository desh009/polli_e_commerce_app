// lib/core/screen/add_To_cart_screen/cart_item/cart_item.dart
class CartItem {
  final int id;
  final String name;
  final String category;
  final double price;
  int quantity; // ✅ REMOVE 'final' from quantity
  final String imagePath;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity, // ✅ Now mutable
    required this.imagePath,
  });

  double get totalPrice => price * quantity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CartItem{id: $id, name: $name, quantity: $quantity, price: $price}';
  }
}
