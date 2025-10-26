import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/api_response.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/product_api_response.dart';

abstract class BaseProductRepository {
  Future<List<ProductModel>> getAllProducts();
  Future<List<ProductModel>> getProductsByCategory(int categoryId);
  Future<ProductModel?> getProductById(int productId);
  Future<List<ProductModel>> searchProducts(String query);
}

class ProductRepository implements BaseProductRepository {
  final NetworkClient _networkClient;

  ProductRepository(this._networkClient);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final NetworkResponse response = await _networkClient.getRequest(Url.productList);

    if (response.isSuccess && response.responseData != null) {
      final data = response.responseData!;
      final productResponse = ProductApiResponse.fromJson(data);
      return productResponse.products.data;
    } else {
      throw Exception(response.errorMessage ?? 'Failed to fetch products');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final NetworkResponse response = await _networkClient.getRequest(
      Url.productsByCategory(categoryId),
    );

    if (response.isSuccess && response.responseData != null) {
      final data = response.responseData!;
      final productResponse = ProductApiResponse.fromJson(data);
      return productResponse.products.data;
    } else {
      throw Exception(response.errorMessage ?? 'Failed to fetch category products');
    }
  }

  @override
  Future<ProductModel?> getProductById(int productId) async {
    final NetworkResponse response = await _networkClient.getRequest(
      Url.productById(productId),
    );

    if (response.isSuccess && response.responseData != null) {
      final data = response.responseData!;
      return ProductModel.fromJson(data);
    } else {
      throw Exception(response.errorMessage ?? 'Failed to fetch product');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    // First get all products
    final allProducts = await getAllProducts();
    
    // Then filter locally based on query
    return allProducts.where((product) => 
      product.title.toLowerCase().contains(query.toLowerCase()) ||
      product.categories.any((category) => 
        category.title.toLowerCase().contains(query.toLowerCase())
      )
    ).toList();
  }
}