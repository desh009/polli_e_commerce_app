// lib/core/screen/check_out_screen/controller/chek_out_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/check_out_screen/chek_out_response_model/chek_out_response_model.dart';
import 'package:polli_e_commerce_app/core/screen/check_out_screen/repository/chek_out_repository.dart';
import 'package:polli_e_commerce_app/core/screen/order_successfull_screen/oder_sucessfull_screen.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class CheckoutController extends GetxController {
  final CartController _cartController = Get.find<CartController>();
  final OrderRepository _orderRepository = Get.find<OrderRepository>();

  // === CUSTOMER INFORMATION ===
  final customerName = ''.obs;
  final phone = ''.obs;
  final address = ''.obs;

  // === ORDER INFORMATION ===
  final totalPrice = 0.0.obs;
  final totalQuantity = 0.obs;
  final totalDiscount = 0.0.obs;
  final deliveryCharge = 20.0.obs;

  // === PAYMENT INFORMATION ===
  final paymentType = 0.obs;
  final saleType = 2.obs;
  final returnCash = 0.0.obs;
  final givenPayment = '0'.obs;

  // === BANK INFORMATION ===
  final bankName = ''.obs;
  final bankRefNumber = ''.obs;

  // === UI STATE ===
  final isLoading = false.obs;

  // === GETTERS ===
  double get grandTotal => totalPrice.value + deliveryCharge.value - totalDiscount.value;

  @override
  void onInit() {
    super.onInit();
    _initializeCartData();
    _setupListeners();
  }

  void _initializeCartData() {
    try {
      double calculatedTotal = 0.0;
      int calculatedQuantity = 0;

      for (final item in _cartController.cartItems) {
        calculatedTotal += item.price * item.quantity;
        calculatedQuantity += item.quantity;
      }

      totalPrice.value = calculatedTotal;
      totalQuantity.value = calculatedQuantity;
      
      print('✅ Cart data initialized:');
      print('   - Total Price: $calculatedTotal');
      print('   - Total Quantity: $calculatedQuantity');
      print('   - Items Count: ${_cartController.cartItems.length}');
    } catch (e) {
      print('❌ Error initializing cart data: $e');
      totalPrice.value = 0.0;
      totalQuantity.value = 0;
    }
  }

  void _setupListeners() {
    ever(givenPayment, (_) => _updateReturnCash());
  }

  void _updateReturnCash() {
    final given = double.tryParse(givenPayment.value) ?? 0;
    returnCash.value = given > grandTotal ? given - grandTotal : 0;
  }

  // === CART ITEMS PREPARATION ===
  Map<String, Cart2Item> _prepareCartItems() {
    final Map<String, Cart2Item> cartItems = {};

    for (final item in _cartController.cartItems) {
      cartItems[item.id.toString()] = Cart2Item(
        quantity: item.quantity,
        discount: 0,
      );
    }

    print('✅ Cart items prepared: ${cartItems.length} items');
    return cartItems;
  }

  // === ORDER CREATION ===
  OrderModel _createOrderModel() {
    final order = OrderModel(
      name: customerName.value,
      phone: phone.value,
      address: address.value,
      cartItems: _prepareCartItems(),
      totalPrice: totalPrice.value,
      totalQuantity: totalQuantity.value,
      totalDiscount: totalDiscount.value,
      paymentType: paymentType.value,
      saleType: saleType.value,
      returnCash: returnCash.value,
      deliveryCharge: deliveryCharge.value,
      givenPayment: double.tryParse(givenPayment.value) ?? 0,
      bankName: bankName.value,
      bankRefNumber: bankRefNumber.value,
    );

    print('📦 Order Model Created:');
    print('   - Name: ${order.name}');
    print('   - Phone: ${order.phone}');
    print('   - Total Price: ${order.totalPrice}');
    print('   - Cart Items: ${order.cartItems.length}');
    
    return order;
  }

  // === VALIDATION ===
  bool _validateForm() {
    if (customerName.value.isEmpty) {
      _showError('Please enter your name');
      return false;
    }

    if (phone.value.isEmpty) {
      _showError('Please enter your phone number');
      return false;
    }

    if (address.value.isEmpty) {
      _showError('Please enter your address');
      return false;
    }

    if (_cartController.cartItems.isEmpty) {
      _showError('Your cart is empty');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
    );
  }

  // === ORDER PLACEMENT ===
  Future<void> placeOrder() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      print('🚀 Starting order placement process...');
      
      final order = _createOrderModel();
      final response = await _orderRepository.placeOrder(order);

      print('📨 Order Repository Response:');
      print('   - Success: ${response.success}');
      print('   - Message: ${response.message}');
      print('   - Order ID: ${response.orderId}');

      if (response.success) {
        _handleOrderSuccess(response);
      } else {
        _handleOrderFailure(response.message);
      }
    } catch (e) {
      print('💥 Order placement error: $e');
      _handleOrderFailure('Network error: $e');
    } finally {
      isLoading.value = false;
      print('🏁 Order placement process completed');
    }
  }

  void _handleOrderSuccess(OrderResponse response) {
    print('🎉 Order placed successfully! Order ID: ${response.orderId}');
    
    _cartController.clearCart();
    
    _showSuccess('Order #${response.orderId} placed successfully!');
    
    // Navigate to success screen
    Get.offAll(() => OrderSuccessScreen());
  }

  void _handleOrderFailure(String message) {
    print('❌ Order failed: $message');
    
    Get.snackbar(
      'Order Failed',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  // === UTILITY METHODS ===
  void fillDummyData() {
    customerName.value = 'John Doe';
    phone.value = '01712345678';
    address.value = '123, Dhaka, Bangladesh';
    givenPayment.value = grandTotal.toStringAsFixed(2);

    print('📝 Demo data filled');
    _showSuccess('Demo data loaded successfully');
  }

  void clearForm() {
    customerName.value = '';
    phone.value = '';
    address.value = '';
    givenPayment.value = '0';
    bankName.value = '';
    bankRefNumber.value = '';
    paymentType.value = 0;
    saleType.value = 2;

    print('🗑️ Form cleared');
  }

  void refreshCartData() {
    _initializeCartData();
  }
}