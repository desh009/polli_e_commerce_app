// lib/core/screen/catergory/check_out_screen/repository/chek_out_repository.dart
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/cart_item/cart_item.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';

class CheckoutRepository {
  final dynamic networkClient; // আপনার NetworkClient

  CheckoutRepository({required this.networkClient});

  Future<CheckoutResponse> placeOrder({
    required String customerName,
    required String phone,
    required String email,
    required String address,
    required List<CartItem> items,
    required double subtotal,
    required double deliveryCharge,
    required String paymentMethod,
  }) async {
    try {
      // TODO: Implement actual API call
      final orderData = {
        'customer_name': customerName,
        'phone': phone,
        'email': email,
        'address': address,
        'items': items.map((item) => {
          'product_id': item.id,
          'product_name': item.name,
          'quantity': item.quantity,
          'price': item.price,
          'total_price': item.totalPrice,
        }).toList(),
        'subtotal': subtotal,
        'delivery_charge': deliveryCharge,
        'grand_total': subtotal + deliveryCharge,
        'payment_method': paymentMethod,
      };

      print('📦 Order Data to API: $orderData');

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Simulate successful response
      return CheckoutResponse(
        success: true,
        orderId: 'ORD${DateTime.now().millisecondsSinceEpoch}',
        message: 'Order placed successfully',
        data: orderData,
      );
    } catch (e) {
      print('❌ Checkout API Error: $e');
      return CheckoutResponse(
        success: false,
        message: e.toString(),
      );
    }
  }
}

class CheckoutResponse {
  final bool success;
  final String? orderId;
  final String? message;
  final dynamic data;

  CheckoutResponse({
    required this.success,
    this.orderId,
    this.message,
    this.data,
  });
}