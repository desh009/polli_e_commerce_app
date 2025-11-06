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
  void refreshCheckoutData(dynamic isLoading) {
    // Implement your refresh logic here
    isLoading.value = true;
    // Fetch data again
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });
  }
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
    
    // ✅ REMOVED: Problematic ever() listener that caused back button issues
    // ❌ ever(cartController.cartItems, (_) { update(); });
    
    print('🔄 CheckoutController initialized');
    print('🛒 Cart items count: ${cartItems.length}');
  }

  @override
  void onClose() {
    print('🔚 CheckoutController closed');
    super.onClose();
  }

  void _loadCustomerInfo() {
    // Load customer info from API or shared preferences
    customerName.value = 'Desh Bala';
    phone.value = '01936656149';
    email.value = 'customer@example.com';
    address.value = 'Suvodia Aimatola, Gourambha, Bagerhat, Khulna';
    
    print('👤 Customer info loaded: ${customerName.value}');
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
    
    print('📝 Customer info updated: $name');
  }

  void updateDeliveryCharge(double charge) {
    deliveryCharge.value = charge;
    print('🚚 Delivery charge updated: $charge');
  }

  void updatePaymentMethod(String method) {
    selectedPaymentMethod.value = method;
    print('💳 Payment method updated: $method');
  }

  bool validateCustomerInfo() {
    final isValid = customerName.value.isNotEmpty &&
           phone.value.isNotEmpty &&
           address.value.isNotEmpty;
    
    print('🔍 Customer info validation: $isValid');
    return isValid;
  }

  Map<String, dynamic> getOrderSummary() {
    final summary = {
      'subtotal': totalPrice,
      'delivery_charge': deliveryCharge.value,
      'grand_total': grandTotal,
      'item_count': cartItems.length,
      'total_quantity': cartItems.fold(0, (sum, item) => sum + item.quantity),
    };
    
    print('📊 Order summary: $summary');
    return summary;
  }

  Future<void> placeOrder() async {
    if (cartItems.isEmpty) {
      print('❌ Cart is empty');
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
      print('❌ Customer info invalid');
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
    print('🚀 Starting order placement process...');

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
        print('✅ Order placed successfully: ${response.orderId}');
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
        print('🛒 Cart cleared after successful order');

        // Navigate to Order Success Screen
        Get.offAll(() => const OrderSuccessScreen());
        print('🎊 Navigated to order success screen');
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
      print('🔄 Button loading state reset');
    }
  }
}