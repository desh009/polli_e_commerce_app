import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/check_out_screen/binder/chek_out_binder.dart';
import 'package:polli_e_commerce_app/core/screen/check_out_screen/controller/chek_out_controller.dart';
import 'package:polli_e_commerce_app/core/screen/check_out_screen/view/chek_out_view.dart';

class CartScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  CartScreen({super.key, required this.product});

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(
            () => cartController.cartItems.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.white),
                    onPressed: () {
                      _showClearCartDialog(context);
                    },
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return _buildEmptyCart();
        }
        return Column(
          children: [
            // Section 1: Element (Cart Items)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        '1. Element',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartController.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartController.cartItems[index];
                        return _buildCartItem(item);
                      },
                    ),

                    // Price Summary
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          _buildPriceRow(
                            'Subtotal:',
                            '৳${_calculateSubtotal()}',
                          ),
                          _buildPriceRow('Delivery:', '৳500.00'),
                          _buildPriceRow('Discount:', '৳300.00'),
                          const SizedBox(height: 10),
                          Container(height: 1, color: Colors.grey.shade300),
                          const SizedBox(height: 10),
                          _buildPriceRow(
                            'Total:',
                            '৳${_calculateTotal()}',
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Section 2: Directional (Checkout Section)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2. Directional',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _navigateToCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // Checkout এ navigate করার মেথড - FIXED VERSION
// CartScreen এ
void _navigateToCheckout() {
  if (cartController.cartItems.isEmpty) {
    Get.snackbar(
      'Cart Empty',
      'Please add items to cart before checkout',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
    return;
  }

  try {
    // CheckoutController পাওয়া এবং data set করা
    final checkoutController = Get.find<CheckoutController>();
    checkoutController.refreshCartData();
    
    // Navigate to CheckoutScreen
    Get.to(() => CheckoutScreen());
    
    // অথবা Named Route ব্যবহার করুন
    // Get.toNamed(Routes.CHECKOUT);
    
  } catch (e) {
    print('Error navigating to checkout: $e');
    Get.snackbar(
      'Error',
      'Could not open checkout screen',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
  // Calculate subtotal from cart items
  double _calculateSubtotal() {
    double total = 0.0;
    for (var item in cartController.cartItems) {
      total += (item.price * item.quantity);
    }
    return total;
  }

  // Calculate total with delivery and discount
  double _calculateTotal() {
    return _calculateSubtotal() + 500 - 300;
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add some products to get started',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Continue Shopping',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey.shade400,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.category,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '৳${item.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        cartController.updateQuantity(
                          item.id,
                          item.quantity - 1,
                        );
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.red,
                    ),
                    Obx(() {
                      final currentItem = cartController.cartItems.firstWhere(
                        (e) => e.id == item.id,
                        orElse: () => item,
                      );
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${currentItem.quantity}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                    IconButton(
                      onPressed: () {
                        cartController.updateQuantity(
                          item.id,
                          item.quantity + 1,
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final currentItem = cartController.cartItems.firstWhere(
                    (e) => e.id == item.id,
                    orElse: () => item,
                  );
                  return Text(
                    'Total: ৳${(currentItem.price * currentItem.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cartController.clearCart();
              Navigator.of(context).pop();
              Get.snackbar(
                'Cart Cleared',
                'All items removed',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _processOrder() {
    Get.snackbar(
      'Order Placed!',
      'Your order has been placed successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
    cartController.clearCart();
  }
}