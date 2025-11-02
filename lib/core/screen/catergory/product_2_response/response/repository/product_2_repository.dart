// lib/core/repositories/product_detail_repository.dart

import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';

import 'package:polli_e_commerce_app/core/screen/catergory/product_2_response/response/product_2_response.dart';

abstract class BaseProductDetailRepository {
  Future<SingleProductModel> getProductDetail(int productId);
}

class ProductDetailRepository implements BaseProductDetailRepository {
  final NetworkClient _networkClient;

  ProductDetailRepository({required NetworkClient networkClient}) 
      : _networkClient = networkClient;

  @override
  Future<SingleProductModel> getProductDetail(int productId) async {
    try {
      final url = Url.productById(productId);
      print('🔄 Fetching product from: $url');
      
      final response = await _networkClient.getRequest(url);
      
      // Check if request was successful
      if (!response.isSuccess) {
        throw Exception(response.errorMessage ?? 'Failed to load product');
      }

      final responseData = response.responseData;
      
      if (responseData == null) {
        throw Exception('No data received from server');
      }

      print('🔍 Raw Response Data Type: ${responseData.runtimeType}');
      print('🔍 Raw Response Data: $responseData');

      // Handle your specific API structure: { "product": { ... } }
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('product')) {
          print('✅ Found product key in response');
          final productData = responseData['product'];
          
          if (productData is Map<String, dynamic>) {
            return SingleProductModel.fromJson(productData);
          } else {
            throw Exception('Product data is not in expected format');
          }
        } else {
          throw Exception('Product key not found in response');
        }
      } else {
        throw Exception('Invalid response format: Expected Map');
      }
      
    } catch (e) {
      print('❌ Error in getProductDetail: $e');
      throw Exception('Failed to load product details: $e');
    }
  }
}