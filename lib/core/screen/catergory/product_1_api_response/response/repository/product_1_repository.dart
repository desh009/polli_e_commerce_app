// lib/core/screen/catergory/product_1_api_response/response/repository/product_1_repository.dart

import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/product_response_model/product_response_model.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/product_1_response.dart';

class ProductRepository {
  final NetworkClient networkClient;

  // ✅ Fixed constructor
  ProductRepository(this.networkClient);

  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final response = await networkClient.getRequest(Url.productList);

      if (response.isSuccess) {
        final responseData = response.responseData;

        if (responseData != null && responseData.containsKey('products')) {
          final productsData = responseData['products'];

          if (productsData is Map<String, dynamic>) {
            final productListResponse = ProductListResponse.fromJson(productsData);
            print('✅ Loaded ${productListResponse.data.length} products from API');
            return productListResponse.data;
          }
        }

        print('❌ Unexpected API response structure');
        return [];
      } else {
        throw Exception(response.errorMessage ?? 'Failed to fetch products');
      }
    } catch (e) {
      print('❌ Error in fetchAllProducts: $e');
      rethrow;
    }
  }

  Future<List<ProductModel>> fetchProductsByCategory(int categoryId) async {
    try {
      final allProducts = await fetchAllProducts();
      final filtered = allProducts.where((p) => p.parsedCategoryIds.contains(categoryId)).toList();
      print('🎯 Filtered ${filtered.length} products for category ID: $categoryId');
      return filtered;
    } catch (e) {
      print('❌ Error filtering products by category: $e');
      throw Exception('Failed to fetch products by category: $e');
    }
  }

  Future<ProductModel> fetchProductById(int id) async {
    try {
      final response = await networkClient.getRequest(Url.productById(id));
      if (response.isSuccess) {
        final responseData = response.responseData;
        if (responseData != null && responseData.containsKey('product')) {
          return ProductModel.fromJson(responseData['product']);
        } else if (responseData is Map<String, dynamic>) {
          return ProductModel.fromJson(responseData);
        } else {
          throw Exception('Invalid product data format');
        }
      } else {
        throw Exception(response.errorMessage ?? 'Failed to fetch product');
      }
    } catch (e) {
      print('❌ Error fetching product by ID: $e');
      rethrow;
    }
  }
}
