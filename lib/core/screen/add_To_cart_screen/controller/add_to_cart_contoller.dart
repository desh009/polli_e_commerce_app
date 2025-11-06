import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/cart_item/cart_item.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void addToCart(CartItem item) {
    print('🛒 Adding to cart: ${item.name} (ID: ${item.id})');
    
    // ✅ Check if item already exists in cart
    int index = cartItems.indexWhere((i) => i.id == item.id);
    
    if (index != -1) {
      // ✅ Update quantity if item exists
      cartItems[index] = CartItem(
        id: item.id,
        name: item.name,
        category: item.category,
        price: item.price,
        quantity: cartItems[index].quantity + item.quantity,
        imagePath: item.imagePath,
      );
      print('✅ Cart item quantity updated: ${item.name}');
    } else {
      // ✅ Add new item to cart
      cartItems.add(item);
      print('✅ New item added to cart: ${item.name}');
    }
    
    // ✅ Force refresh the list
    cartItems.refresh();
    
    // ✅ Debug information
    print('📦 Cart items count: ${cartItems.length}');
    print('💰 Cart subtotal: $subtotal');
    print('🛒 Current cart items:');
    cartItems.forEach((item) {
      print('   - ${item.name} (Qty: ${item.quantity}, Price: ${item.price})');
    });
  }

  void removeFromCart(CartItem item) {
    print('🗑️ Removing from cart: ${item.name}');
    cartItems.remove(item);
    cartItems.refresh();
    print('✅ Item removed from cart');
  }

  double get subtotal =>
      cartItems.fold(0, (sum, i) => sum + (i.price * i.quantity));

  double get deliveryCharge => cartItems.isEmpty ? 0 : 135;

  double get grandTotal => subtotal + deliveryCharge;

  void updateQuantity(int id, int newQuantity) {
    print('🔢 Updating quantity for ID: $id to $newQuantity');
    
    final itemIndex = cartItems.indexWhere((e) => e.id == id);
    if (itemIndex != -1) {
      if (newQuantity <= 0) {
        // Remove item if quantity is 0 or less
        cartItems.removeAt(itemIndex);
        print('❌ Item removed (quantity 0)');
      } else {
        // Update quantity
        final oldItem = cartItems[itemIndex];
        cartItems[itemIndex] = CartItem(
          id: oldItem.id,
          name: oldItem.name,
          category: oldItem.category,
          price: oldItem.price,
          quantity: newQuantity,
          imagePath: oldItem.imagePath,
        );
        print('✅ Quantity updated to: $newQuantity');
      }
      cartItems.refresh();
    } else {
      print('❌ Item not found in cart: $id');
    }
  }

  void clearCart() {
    print('🗑️ Clearing entire cart...');
    cartItems.clear();
    cartItems.refresh();
    print('✅ Cart cleared');
  }

  // ✅ New method to check if cart is working
  void debugCart() {
    print('=== CART DEBUG INFO ===');
    print('📦 Total items: $totalItems');
    print('💰 Subtotal: $subtotal');
    print('🚚 Delivery charge: $deliveryCharge');
    print('💵 Grand total: $grandTotal');
    print('🛒 Items in cart:');
    if (cartItems.isEmpty) {
      print('   - Cart is empty');
    } else {
      cartItems.forEach((item) {
        print('   - ${item.name} (ID: ${item.id}, Qty: ${item.quantity}, Price: ${item.price})');
      });
    }
    print('=======================');
  }
}