// lib/core/screen/add_To_cart_screen/view/add_to_cart_scree.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/cart_item/cart_item.dart';
import 'package:polli_e_commerce_app/core/widgets/auth_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/view/chek_out_view.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Login_screen.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';

class CartScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  CartScreen({super.key, required this.product});

  final CartController cartController = Get.find<CartController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.green,
        actions: [
          Obx(() => cartController.cartItems.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () => _showClearCartDialog(context),
                )
              : const SizedBox()),
        ],
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return _buildEmptyCart();
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return _buildCartItem(item);
                },
              ),
            ),
            _buildCartSummary(),
          ],
        );
      }),
    );
  }

  // 🛒 Empty Cart Widget
  Widget _buildEmptyCart() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Add some products to get started',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      );

  // 🧾 Cart Item UI
  Widget _buildCartItem(CartItem item) => Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(item.category,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text('৳${item.price}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green)),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => cartController.updateQuantity(
                            item.id, item.quantity - 1),
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('${item.quantity}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        onPressed: () => cartController.updateQuantity(
                            item.id, item.quantity + 1),
                        icon: const Icon(Icons.add_circle_outline),
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Total: ৳${item.totalPrice}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ],
          ),
        ),
      );

  // 💰 Cart Summary + Checkout Button
  Widget _buildCartSummary() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Items:', style: TextStyle(fontSize: 16)),
                Obx(() => Text('${cartController.totalItems}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Price:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Obx(() => Text('৳${cartController.totalPrice}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _processCheckout,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Proceed to Checkout',
                    style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      );

  // 🧹 Clear Cart Dialog
  void _showClearCartDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text('Are you sure you want to remove all items?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  cartController.clearCart();
                  Navigator.of(context).pop();
                  Get.snackbar('Cart Cleared', 'All items removed',
                      backgroundColor: Colors.orange, colorText: Colors.white);
                },
                child: const Text('Clear',
                    style: TextStyle(color: Colors.red))),
          ],
        ),
      );

  // 🚀 Checkout Logic with Login Check (AlertDialog বাদ)
  void _processCheckout() {
    if (!authController.isLoggedIn.value) {
      // লগইন না থাকলে pendingAction সেট কর
      authController.pendingAction = () {
        Get.to(() => CheckoutScreen());
      };
      // LoginScreen খুল
      Get.to(() => LoginScreen());
      return;
    }

    // Already logged in হলে সরাসরি CheckoutScreen
    Get.to(() => CheckoutScreen());
  }
}
