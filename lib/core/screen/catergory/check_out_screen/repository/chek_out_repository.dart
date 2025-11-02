// lib/core/screen/catergory/check_out_screen/repository/checkout_repository.dart

import 'package:polli_e_commerce_app/core/network/api_client.dart';

abstract class BaseCheckoutRepository {
  Future<Map<String, dynamic>> placeOrder(Map<String, dynamic> orderData);
  Future<List<Map<String, dynamic>>> getPaymentMethods();
  Future<Map<String, dynamic>> validateOrder(Map<String, dynamic> orderData);
}

class CheckoutRepository implements BaseCheckoutRepository {
  final NetworkClient _networkClient;

  CheckoutRepository({required NetworkClient networkClient})
      : _networkClient = networkClient;

  @override
  Future<Map<String, dynamic>> placeOrder(Map<String, dynamic> orderData) async {
    try {
      print('🛒 Placing order with data: $orderData');
      
      final response = await _networkClient.postRequest(
        '/api/orders',
        body: orderData,
      );

      // ✅ Handle NetworkResponse and extract data
      if (response.isSuccess) {
        print('✅ Order placed successfully');
        
        // If response has data, return it
        if (response.responseData != null) {
          return response.responseData as Map<String, dynamic>;
        } else {
          // Return success message if no data
          return {
            'success': true,
            'message': 'Order placed successfully',
            'order_id': DateTime.now().millisecondsSinceEpoch.toString(),
          };
        }
      } else {
        throw Exception(response.errorMessage ?? 'Failed to place order');
      }
    } catch (e) {
      print('❌ Error placing order: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    try {
      print('💰 Fetching payment methods...');
      
      // Simulate API call - আপনার actual endpoint দিয়ে replace করবেন
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock payment methods data
      final paymentMethods = [
        {
          'id': 0,
          'name': 'Cash on Delivery',
          'description': 'Pay when your order is delivered',
          'icon': 'cash',
          'is_active': true,
        },
        {
          'id': 1,
          'name': 'Bank Transfer',
          'description': 'Bank transfer details will be shown',
          'icon': 'bank',
          'is_active': true,
        },
        {
          'id': 2,
          'name': 'bKash',
          'description': 'Pay via bKash mobile banking',
          'icon': 'mobile',
          'is_active': true,
        },
        {
          'id': 3,
          'name': 'Nagad',
          'description': 'Pay via Nagad mobile banking',
          'icon': 'mobile',
          'is_active': true,
        },
        {
          'id': 4,
          'name': 'Rocket',
          'description': 'Pay via DBBL Rocket',
          'icon': 'mobile',
          'is_active': true,
        },
        {
          'id': 5,
          'name': 'AamarPay',
          'description': 'Secure online payment',
          'icon': 'card',
          'is_active': true,
        },
      ];

      print('✅ Payment methods loaded: ${paymentMethods.length} methods');
      return paymentMethods;
    } catch (e) {
      print('❌ Error fetching payment methods: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> validateOrder(Map<String, dynamic> orderData) async {
    try {
      print('🔍 Validating order data...');
      
      // Validate required fields
      final requiredFields = ['customer_name', 'phone', 'address', 'payment_type'];
      
      for (final field in requiredFields) {
        if (orderData[field] == null || orderData[field].toString().isEmpty) {
          throw Exception('$field is required');
        }
      }

      // Validate phone number
      final phone = orderData['phone'].toString();
      if (phone.length < 11) {
        throw Exception('Phone number must be at least 11 digits');
      }

      // Validate payment type
      final paymentType = orderData['payment_type'];
      if (paymentType < 0 || paymentType > 5) {
        throw Exception('Invalid payment method');
      }

      // If bank transfer, validate bank details
      if (paymentType == 1) {
        if (orderData['bank_name'] == null || orderData['bank_name'].toString().isEmpty) {
          throw Exception('Bank name is required for bank transfer');
        }
      }

      print('✅ Order validation successful');
      return {'success': true, 'message': 'Order data is valid'};
    } catch (e) {
      print('❌ Order validation failed: $e');
      rethrow;
    }
  }
}