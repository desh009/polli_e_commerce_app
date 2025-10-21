import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/api_response.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/response/category_response.dart';

class Category1Repository {
  final NetworkClient networkClient;

  Category1Repository(this.networkClient);

  /// ---- Get All Categories ----
  Future<List<Category>> getCategories() async {
    final NetworkResponse response = await networkClient.getRequest(Url.categoryList);

    if (response.isSuccess) {
      final data = response.responseData;
      if (data is Map<String, dynamic> && data.containsKey('categories')) {
        final List<dynamic> categories = data['categories'];
        return categories.map((e) => Category.fromJson(e)).toList();
      }
      throw FormatException("Invalid response format: categories key not found");
    } else {
      throw Exception(response.errorMessage ?? "Failed to fetch categories");
    }
  }

  /// ---- Create Category ----
  Future<Category> createCategory(Map<String, dynamic> body) async {
    final NetworkResponse response = await networkClient.postRequest(
      Url.categoryList, 
      body: body
    );

    if (response.isSuccess) {
      return _parseCategoryResponse(response.responseData);
    } else {
      throw Exception(response.errorMessage ?? "Failed to create category");
    }
  }

  /// ---- Update Category ----
  Future<Category> updateCategory(int id, Map<String, dynamic> body) async {
    final NetworkResponse response = await networkClient.putRequest(
      "${Url.categoryList}/$id", 
      body: body
    );

    if (response.isSuccess) {
      return _parseCategoryResponse(response.responseData);
    } else {
      throw Exception(response.errorMessage ?? "Failed to update category");
    }
  }

  /// ---- Delete Category ----
  Future<bool> deleteCategory(int id) async {
    final NetworkResponse response = await networkClient.deleteRequest(
      "${Url.categoryList}/$id"
    );

    if (response.isSuccess) {
      return true;
    } else {
      throw Exception(response.errorMessage ?? "Failed to delete category");
    }
  }

  /// ---- Helper method to parse category response ----
  Category _parseCategoryResponse(dynamic responseData) {
    if (responseData == null) {
      throw FormatException("Response data is null");
    }

    if (responseData is Map<String, dynamic>) {
      // Try different possible response formats
      if (responseData.containsKey("data")) {
        return Category.fromJson(responseData["data"]);
      } else if (responseData.containsKey("category")) {
        return Category.fromJson(responseData["category"]);
      } else {
        // Direct category data
        return Category.fromJson(responseData);
      }
    }
    
    throw FormatException("Invalid response format for category");
  }
}