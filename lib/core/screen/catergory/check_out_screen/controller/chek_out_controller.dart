// lib/core/screen/catergory/check_out_screen/controller/chek_out_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/cart_item/cart_item.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/repository/chek_out_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/order_successfull_screen/oder_sucessfull_screen.dart';

class CheckoutController extends GetxController {
  final CheckoutRepository checkoutRepository;
  final CartController cartController;

  CheckoutController({
    required this.checkoutRepository,
    required this.cartController,
  });

  // Customer Information
  var customerName = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;
  var email = ''.obs;

  // Order Information
  var deliveryCharge = 135.0.obs;
  var isButtonLoading = false.obs;

  // Payment Method
  var selectedPaymentMethod = 'Cash on Delivery'.obs;

  // Reactive cart items
  RxList<CartItem> get cartItems => cartController.cartItems;

  // Totals
  double get totalPrice => cartController.subtotal;
  double get grandTotal => totalPrice + deliveryCharge.value;

  @override
  void onInit() {
    super.onInit();
    _loadCustomerInfo();

    // Auto refresh totals when cart changes
    ever(cartController.cartItems, (_) {
      update(); // refresh UI when cart changes
    });
  }

  void _loadCustomerInfo() {
    // TODO: Load customer info from API or shared preferences
    customerName.value = 'Desh Bala';
    phone.value = '01936656149';
    email.value = 'customer@example.com';
    address.value = 'Suvodia Aimatola, Gourambha, Bagerhat, Khulna';
  }

  void updateCustomerInfo(String name, String phoneNumber, String customerAddress, String customerEmail) {
    customerName.value = name;
    phone.value = phoneNumber;
    address.value = customerAddress;
    email.value = customerEmail;
  }

  void updateDeliveryCharge(double charge) {
    deliveryCharge.value = charge;
  }

  void updatePaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  bool validateCustomerInfo() {
    return customerName.value.isNotEmpty &&
           phone.value.isNotEmpty &&
           address.value.isNotEmpty;
  }

  Map<String, dynamic> getOrderSummary() {
    return {
      'subtotal': totalPrice,
      'delivery_charge': deliveryCharge.value,
      'grand_total': grandTotal,
      'item_count': cartItems.length,
      'total_quantity': cartItems.fold(0, (sum, item) => sum + item.quantity),
    };
  }

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

  if (!validateCustomerInfo()) {
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

  try {
    print('🚀 Placing order...');

    final response = await checkoutRepository.placeOrder(
      customerName: customerName.value,
      phone: phone.value,
      email: email.value,
      address: address.value,
      items: cartItems,
      subtotal: totalPrice,
      deliveryCharge: deliveryCharge.value,
      paymentMethod: selectedPaymentMethod.value,
    );

    if (response.success) {
      Get.snackbar(
        'Order Placed! 🎉',
        'Your order #${response.orderId} has been placed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Clear cart after successful order
      cartController.clearCart();

      // Navigate to Order Success Screen
      Get.offAll(() => const OrderSuccessScreen());
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
  }
}

}
