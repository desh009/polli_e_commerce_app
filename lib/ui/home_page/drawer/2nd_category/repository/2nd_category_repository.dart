// category2_repository.dart
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/2nd_category_model/2nd_category_model.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/response/2nd_category_response.dart';

class Category2Repository {
  final NetworkClient client;

  Category2Repository(this.client);

  Future<Category2Response> getCategoryDetails(int categoryId) async {
    final response = await client.getRequest(Url.categoryById(categoryId));

    if (response.isSuccess && response.responseData != null) {
      return Category2Response.fromJson(response.responseData as Map<String, dynamic>);
    } else {
      throw Exception(response.errorMessage ?? "Failed to fetch category details");
    }
  }

  Future<List<Category2>> getCategoryChildren(int categoryId) async {
    final response = await client.getRequest(Url.categoryById(categoryId));

    if (response.isSuccess && response.responseData != null) {
      final data = response.responseData as Map<String, dynamic>;
      final childrenList = data['children'] as List<dynamic>? ?? [];
      return childrenList.map((childJson) => Category2.fromJson(childJson)).toList();
    } else {
      throw Exception(response.errorMessage ?? "Failed to fetch category children");
    }
  }
}