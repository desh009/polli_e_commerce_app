class CartItem {
  final int id;
  final String name; // ✅ এই property আছে
  final String category;
  final String imagePath; // ✅ এই property আছে
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