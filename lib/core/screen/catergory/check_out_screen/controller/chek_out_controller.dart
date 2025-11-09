import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/cart_item/cart_item.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/repository/chek_out_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/view/chek_out_view.dart';
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

  // OTP Verification Status
  var isVerified = false.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;

  // Reactive cart items
  RxList<CartItem> get cartItems => cartController.cartItems;

  // Totals - Automatic updates with Obx
  double get totalPrice => cartController.subtotal;
  double get grandTotal => totalPrice + deliveryCharge.value;

  @override
  void onInit() {
    super.onInit();
    _loadCustomerInfo();
    _checkOtpVerification();
    
    print('🔄 CheckoutController initialized');
    print('🛒 Cart items count: ${cartItems.length}');
  }

  void _loadCustomerInfo() {
    // Load customer info from API or shared preferences
    customerName.value = 'Desh Bala';
    phone.value = '01936656149';
    email.value = 'customer@example.com';
    address.value = 'Suvodia Aimatola, Gourambha, Bagerhat, Khulna';
  }

  // ✅ FIXED: PROPER NAVIGATION TO CHECKOUT
  void navigateToCheckout() {
    try {
      print('🔄 Navigating to checkout screen...');
      
      // ✅ CORRECT: Stack maintain করবে
      Get.to(() => CheckoutScreen());
      
      print('✅ Checkout navigation successful');
    } catch (e) {
      print('❌ Checkout navigation error: $e');
      Get.snackbar(
        'Error',
        'Failed to navigate to checkout',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _checkOtpVerification() {
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      isVerified.value = arguments['verified'] ?? false;
      userEmail.value = arguments['email']?.toString() ?? '';
      userPhone.value = arguments['phone']?.toString() ?? '';
      
      if (isVerified.value) {
        // যদি OTP verified হয়, তাহলে customer information সেট করুন
        customerName.value = arguments['email']?.toString().split('@').first ?? 'User';
        phone.value = arguments['phone']?.toString() ?? '';
        email.value = arguments['email']?.toString() ?? '';
        
        print('✅ OTP Verified user: ${userEmail.value}');
        
        Get.snackbar(
          "স্বাগতম!",
          "আপনার অ্যাকাউন্ট সফলভাবে ভেরিফাই করা হয়েছে",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
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

  // ✅ IMPROVED: Better validation
  bool validateCustomerInfo() {
    if (customerName.value.isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return false;
    }
    
    if (phone.value.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number');
      return false;
    }
    
    if (address.value.isEmpty) {
      Get.snackbar('Error', 'Please enter your address');
      return false;
    }
    
    return true;
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

  // ✅ IMPROVED: Better error handling
  Future<void> placeOrder() async {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Cart Empty',
        'Please add items to your cart before placing order',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (!validateCustomerInfo()) {
      return;
    }

    isButtonLoading.value = true;

    try {
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
        // Clear cart after successful order
        cartController.clearCart();

        // Navigate to Order Success Screen
        Get.offAll(() => const OrderSuccessScreen());
        
        Get.snackbar(
          'Order Placed! 🎉',
          'Your order #${response.orderId} has been placed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        throw Exception(response.message ?? 'Failed to place order');
      }
    } catch (e) {
      print('❌ Order placement error: $e');
      Get.snackbar(
        'Order Failed',
        'Failed to place order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isButtonLoading.value = false;
    }
  }

  // ✅ NEW: Check if cart has items
  bool get hasCartItems => cartItems.isNotEmpty;

  // ✅ NEW: Get cart items count
  int get cartItemsCount => cartItems.length;

  // ✅ NEW: Clear all data
  void clearAllData() {
    customerName.value = '';
    phone.value = '';
    address.value = '';
    email.value = '';
    isVerified.value = false;
    userEmail.value = '';
    userPhone.value = '';
  }
}