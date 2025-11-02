// lib/core/screen/catergory/check_out_screen/controller/checkout_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/repository/chek_out_repository.dart';

class CheckoutController extends GetxController {
  final BaseCheckoutRepository _repository;
  final CartController _cartController = Get.find<CartController>();

  CheckoutController({required BaseCheckoutRepository repository})
      : _repository = repository;

  // Customer Information
  final customerName = ''.obs;
  final phone = ''.obs;
  final address = ''.obs;

  // Payment Information
  final paymentType = 0.obs; // 0=Cash, 1=Bank, 2=bKash, 3=Nagad, 4=Rocket, 5=AamarPay
  final bankName = ''.obs;
  final bankRefNumber = ''.obs;

  // Order State
  final isButtonLoading = false.obs;
  final errorMessage = ''.obs;
  final orderSuccess = false.obs;

  // Delivery Charge
  final deliveryCharge = 60.0.obs;

  // ✅ FIXED: Getters for order summary
  int get totalQuantity => _cartController.totalItems;
  
  // ✅ FIXED: Directly use the double value from CartController
  double get totalPrice => _cartController.totalPrice;
  
  double get grandTotal => totalPrice + deliveryCharge.value;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    print('🛒 Initializing checkout controller...');
    print('📊 Cart Summary:');
    print('  - Total Items: $totalQuantity');
    print('  - Total Price: ৳$totalPrice');
    print('  - Delivery Charge: ৳${deliveryCharge.value}');
    print('  - Grand Total: ৳$grandTotal');
  }

  // Validate and place order
  Future<void> placeOrder() async {
    try {
      isButtonLoading.value = true;
      errorMessage.value = '';

      print('🎯 Starting order placement process...');

      // Validate form first
      if (!isFormValid) {
        throw Exception('Please fill all required fields correctly');
      }

      // Check if cart is empty
      if (totalQuantity == 0) {
        throw Exception('Your cart is empty. Please add items to cart first.');
      }

      // Prepare order data
      final orderData = _prepareOrderData();

      // Validate order
      await _repository.validateOrder(orderData);

      // Place order
      final response = await _repository.placeOrder(orderData);

      // Handle success
      _handleOrderSuccess(response);
      
    } catch (e) {
      _handleOrderError(e);
    } finally {
      isButtonLoading.value = false;
    }
  }

  Map<String, dynamic> _prepareOrderData() {
    final cartItems = _cartController.cartItems.map((item) => {
      'product_id': item.id,
      'quantity': item.quantity,
      'price': item.price,
      'name': item.name,
      'total': (item.price * item.quantity).toStringAsFixed(2),
    }).toList();

    return {
      'customer_name': customerName.value,
      'phone': phone.value,
      'address': address.value,
      'payment_type': paymentType.value,
      'bank_name': paymentType.value == 1 ? bankName.value : null,
      'bank_ref_number': paymentType.value == 1 ? bankRefNumber.value : null,
      'items': cartItems,
      'subtotal': totalPrice.toStringAsFixed(2),
      'delivery_charge': deliveryCharge.value.toStringAsFixed(2),
      'grand_total': grandTotal.toStringAsFixed(2),
      'total_quantity': totalQuantity,
      'order_date': DateTime.now().toIso8601String(),
      'status': 'pending',
    };
  }

  void _handleOrderSuccess(Map<String, dynamic> response) {
    print('🎉 Order placed successfully!');
    print('📦 Order Response: $response');
    
    orderSuccess.value = true;
    
    // Clear cart
    _cartController.clearCart();
    
    // Get order ID from response
    final orderId = response['order_id'] ?? 
                   response['data']?['order_id'] ?? 
                   response['id'] ?? 
                   'N/A';
    
    // Show success message
    Get.snackbar(
      'Order Placed Successfully! 🎉',
      'Your order has been confirmed. Order ID: #$orderId',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );

    // Navigate to order confirmation
    _navigateToOrderConfirmation(response);
  }

  void _handleOrderError(dynamic error) {
    print('❌ Order placement failed: $error');
    
    errorMessage.value = error.toString().replaceAll('Exception: ', '');
    
    Get.snackbar(
      'Order Failed ❌',
      errorMessage.value,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  void _navigateToOrderConfirmation(Map<String, dynamic> response) {
    // Navigate back to home after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.until((route) => route.isFirst);
    });
  }

  // Validation methods
  bool validateCustomerInfo() {
    if (customerName.value.isEmpty) {
      errorMessage.value = 'Please enter customer name';
      return false;
    }
    
    if (phone.value.isEmpty) {
      errorMessage.value = 'Please enter phone number';
      return false;
    }
    
    if (address.value.isEmpty) {
      errorMessage.value = 'Please enter delivery address';
      return false;
    }
    
    if (phone.value.length < 11) {
      errorMessage.value = 'Phone number must be at least 11 digits';
      return false;
    }
    
    // Validate phone format (Bangladeshi)
    final phoneRegex = RegExp(r'^(?:\+88|01)?\d{9,11}$');
    if (!phoneRegex.hasMatch(phone.value)) {
      errorMessage.value = 'Please enter a valid Bangladeshi phone number';
      return false;
    }
    
    errorMessage.value = '';
    return true;
  }

  bool validatePaymentInfo() {
    if (paymentType.value == 1) { // Bank transfer
      if (bankName.value.isEmpty) {
        errorMessage.value = 'Please enter bank name for bank transfer';
        return false;
      }
      if (bankRefNumber.value.isEmpty) {
        errorMessage.value = 'Please enter bank reference number';
        return false;
      }
    }
    
    errorMessage.value = '';
    return true;
  }

  bool get isFormValid => validateCustomerInfo() && validatePaymentInfo();

  // Check if cart has items
  bool get hasCartItems => totalQuantity > 0;

  // Utility methods
  void clearForm() {
    customerName.value = '';
    phone.value = '';
    address.value = '';
    paymentType.value = 0;
    bankName.value = '';
    bankRefNumber.value = '';
    errorMessage.value = '';
    orderSuccess.value = false;
  }

  void setDemoData() {
    customerName.value = 'John Doe';
    phone.value = '01712345678';
    address.value = '123, Mirpur, Dhaka, Bangladesh';
    paymentType.value = 0; // Cash on delivery
    
    // For bank transfer demo
    if (paymentType.value == 1) {
      bankName.value = 'Dutch Bangla Bank';
      bankRefNumber.value = 'DBBL${DateTime.now().millisecondsSinceEpoch}';
    }
    
    Get.snackbar(
      'Demo Data Loaded',
      'Test data has been filled automatically',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Update delivery charge
  void updateDeliveryCharge(double charge) {
    deliveryCharge.value = charge;
    print('🚚 Delivery charge updated: ৳$charge');
  }

  @override
  void onClose() {
    print('🛒 Checkout controller closed');
    super.onClose();
  }
}