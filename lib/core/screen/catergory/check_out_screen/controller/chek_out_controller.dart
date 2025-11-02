// lib/core/screen/catergory/check_out_screen/controller/chek_out_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/cart_item/cart_item.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/repository/chek_out_repository.dart';

class CheckoutController extends GetxController {
  final CheckoutRepository checkoutRepository;
  final CartController cartController;

  CheckoutController({
    required this.checkoutRepository,
    required this.cartController, required CheckoutRepository repository,
  });

  // Customer Information
  var customerName = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;
  var email = ''.obs;

  // Order Information
  var deliveryCharge = 135.0.obs;
  var totalPrice = 0.0.obs;
  var isButtonLoading = false.obs;

  // Payment Method
  var selectedPaymentMethod = 'Cash on Delivery'.obs;

  // Cart Items
  var cartItems = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCartItems();
    _loadCustomerInfo();
  }

  void _loadCartItems() {
    cartItems.assignAll(cartController.cartItems);
    _calculateTotalPrice();
    print('🛒 Loaded ${cartItems.length} items to checkout');
  }

  void _loadCustomerInfo() {
    // TODO: Load customer info from shared preferences or API
    customerName.value = 'Desh Bala';
    phone.value = '01936656149';
    email.value = 'customer@example.com';
    address.value = 'Suvodia Aimatola, Gourambha, Bagerhat, Khulna';
  }

  void _calculateTotalPrice() {
    totalPrice.value = cartController.totalPrice;
    print('💰 Total Price: $totalPrice, Delivery: $deliveryCharge');
  }

  // Grand Total calculation
  double get grandTotal => totalPrice.value + deliveryCharge.value;

  // Update customer information
  void updateCustomerInfo(String name, String phoneNumber, String customerAddress, String customerEmail) {
    customerName.value = name;
    phone.value = phoneNumber;
    address.value = customerAddress;
    email.value = customerEmail;
    update();
  }

  // Update delivery charge
  void updateDeliveryCharge(double charge) {
    deliveryCharge.value = charge;
    update();
  }

  // Update payment method
  void updatePaymentMethod(String method) {
    selectedPaymentMethod.value = method;
    update();
  }

  // Place order function
  Future<void> placeOrder() async {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Error',
        'Your cart is empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (customerName.isEmpty || phone.isEmpty || address.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all customer information',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isButtonLoading.value = true;
    update();

    try {
      print('🚀 Placing order...');

      // Repository ব্যবহার করে API call করুন
      final response = await checkoutRepository.placeOrder(
        customerName: customerName.value,
        phone: phone.value,
        email: email.value,
        address: address.value,
        items: cartItems,
        subtotal: totalPrice.value,
        deliveryCharge: deliveryCharge.value,
        paymentMethod: selectedPaymentMethod.value,
      );

      if (response.success) {
        // Show success message
        Get.snackbar(
          'Order Placed! 🎉',
          'Your order #${response.orderId} has been placed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        // Clear cart after successful order
        cartController.clearCart();
        
        // Navigate to home
        await Future.delayed(Duration(seconds: 2));
        Get.until((route) => Get.currentRoute == '/');
        
      } else {
        throw Exception(response.message ?? 'Failed to place order');
      }

    } catch (e) {
      print('❌ Order placement error: $e');
      Get.snackbar(
        'Order Failed',
        'Failed to place order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isButtonLoading.value = false;
      update();
    }
  }

  // Refresh cart items
  void refreshCartItems() {
    _loadCartItems();
    update();
  }

  // Validate customer information
  bool validateCustomerInfo() {
    return customerName.value.isNotEmpty && 
           phone.value.isNotEmpty && 
           address.value.isNotEmpty;
  }

  // Get order summary
  Map<String, dynamic> getOrderSummary() {
    return {
      'subtotal': totalPrice.value,
      'delivery_charge': deliveryCharge.value,
      'grand_total': grandTotal,
      'item_count': cartItems.length,
      'total_quantity': cartItems.fold(0, (sum, item) => sum + item.quantity),
    };
  }

  // Get item image URL
  String getItemImage(CartItem item) {
    return item.imagePath;
  }

  // Get item title
  String getItemTitle(CartItem item) {
    return item.name;
  }

  // Get item price
  double getItemPrice(CartItem item) {
    return item.price;
  }
}