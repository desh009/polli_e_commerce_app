// lib/core/screen/check_out_screen/model/order_model.dart
class OrderModel {
  final String name;
  final String phone;
  final String address;
  final Map<String, Cart2Item> cartItems;
  final double totalPrice;
  final int totalQuantity;
  final double totalDiscount;
  final int paymentType;
  final int saleType;
  final double returnCash;
  final double deliveryCharge;
  final double givenPayment;
  final String bankName;
  final String bankRefNumber;

  OrderModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.cartItems,
    required this.totalPrice,
    required this.totalQuantity,
    required this.totalDiscount,
    required this.paymentType,
    required this.saleType,
    required this.returnCash,
    required this.deliveryCharge,
    required this.givenPayment,
    required this.bankName,
    required this.bankRefNumber,
    required String ? transactionId,
    required String ? paymentMethod,
    required String ? paymentStatus,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    print('🔄 Converting OrderModel to JSON...');

    final cartItemsJson = <String, dynamic>{};
    cartItems.forEach((key, value) {
      cartItemsJson[key] = value?.toJson();
    });

    final json = {
      "name": name,
      "phone": phone,
      "address": address,
      "cart_items": cartItemsJson,
      "total_price": totalPrice,
      "total_quantity": totalQuantity,
      "total_discount": totalDiscount,
      "payment_type": paymentType,
      "sale_type": saleType,
      "return_cash": returnCash,
      "delivery_charge": deliveryCharge,
      "given_payment": givenPayment,
      "bank_name": bankName,
      "bank_ref_number": bankRefNumber,
    };

    print('✅ OrderModel JSON: ${json}');
    return json;
  }

  // Create from JSON (for response)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    print('🔄 Creating OrderModel from JSON...');

    final cartItemsMap = <String, Cart2Item>{};
    if (json['cart_items'] != null) {
      (json['cart_items'] as Map<String, dynamic>).forEach((key, value) {
        cartItemsMap[key] = Cart2Item.fromJson(value);
      });
    }

    return OrderModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      cartItems: cartItemsMap,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      totalQuantity: json['total_quantity'] ?? 0,
      totalDiscount: (json['total_discount'] as num?)?.toDouble() ?? 0.0,
      paymentType: json['payment_type'] ?? 0,
      saleType: json['sale_type'] ?? 2,
      returnCash: (json['return_cash'] as num?)?.toDouble() ?? 0.0,
      deliveryCharge: (json['delivery_charge'] as num?)?.toDouble() ?? 0.0,
      givenPayment: (json['given_payment'] as num?)?.toDouble() ?? 0.0,
      bankName: json['bank_name'] ?? '',
      bankRefNumber: json['bank_ref_number'] ?? '',
      transactionId: '',
      paymentMethod: '',
      paymentStatus: '',
    );
  }
}

class Cart2Item {
  final int quantity;
  final double discount;

  Cart2Item({required this.quantity, required this.discount});

  Map<String, dynamic> toJson() {
    return {"quantity": quantity, "discount": discount};
  }

  factory Cart2Item.fromJson(Map<String, dynamic> json) {
    return Cart2Item(
      quantity: json['quantity'] ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// API Response Model
// lib/core/screen/check_out_screen/model/order_model.dart
class OrderResponse {
  final bool success;
  final String message;
  final int? orderId;
  final Map<String, dynamic>? data;

  OrderResponse({
    required this.success,
    required this.message,
    this.orderId,
    this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    print('🔄 Creating OrderResponse from JSON: $json');

    // API response structure অনুযায়ী check করুন
    final isSuccess = json['status'] == 'success';
    final message = json['message'] ?? 'Unknown error';
    final orderId = json['order_id'];

    return OrderResponse(
      success: isSuccess,
      message: message,
      orderId: orderId,
      data: json,
    );
  }
}
