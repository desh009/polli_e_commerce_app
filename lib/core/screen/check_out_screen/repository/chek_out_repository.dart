// lib/core/screen/check_out_screen/repository/order_repository.dart
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';
import 'package:polli_e_commerce_app/core/screen/check_out_screen/chek_out_response_model/chek_out_response_model.dart';

class OrderRepository {
  final NetworkClient _networkClient = Get.find<NetworkClient>();

  // Place Order Method
  Future<OrderResponse> placeOrder(OrderModel order) async {
    try {
      print('🚀 [ORDER REPO] Starting placeOrder...');
      print('📦 [ORDER REPO] Order Data: ${order.toJson()}');
      print('🌐 [ORDER REPO] API URL: ${Url.checkout}');

      final response = await _networkClient.postRequest(
        Url.checkout,
        body: order.toJson(),
      );

      print('✅ [ORDER REPO] API Response Received:');
      print('   - Status Code: ${response.statusCode}');
      print('   - Is Success: ${response.isSuccess}');
      print('   - Error Message: ${response.errorMessage}');
      print('   - Response Data: ${response.responseData}');

      if (response.isSuccess) {
        final orderResponse = OrderResponse.fromJson(response.responseData!);
        print('🎉 [ORDER REPO] Order placed successfully!');
        return orderResponse;
      } else {
        print('❌ [ORDER REPO] Order failed: ${response.errorMessage}');
        return OrderResponse(
          success: false,
          message: response.errorMessage ?? 'Failed to place order',
        );
      }
    } catch (e, stackTrace) {
      print('💥 [ORDER REPO] Exception occurred:');
      print('   - Error: $e');
      print('   - StackTrace: $stackTrace');
      
      return OrderResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  // Get Order History (if needed)
  Future<OrderResponse> getOrderHistory() async {
    try {
      print('🚀 [ORDER REPO] Fetching order history...');
      
      final response = await _networkClient.getRequest(Url.orderHistory);

      print('✅ [ORDER REPO] Order History Response:');
      print('   - Status Code: ${response.statusCode}');
      print('   - Data: ${response.responseData}');

      if (response.isSuccess) {
        return OrderResponse(
          success: true,
          message: 'Order history fetched successfully',
          data: response.responseData,
        );
      } else {
        return OrderResponse(
          success: false,
          message: response.errorMessage ?? 'Failed to fetch order history',
        );
      }
    } catch (e) {
      print('💥 [ORDER REPO] Order history error: $e');
      return OrderResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }
}