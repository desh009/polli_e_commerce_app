import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/response/category_response.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/2nd_category_response/2nd_category_response.dart';

class Category2Repository {
  final NetworkClient client;

  Category2Repository(this.client);

  /// ক্যাটেগরি ডিটেইলস লোড করা (ক্যাটেগরি + চিলড্রেন)
  Future<Category2Response> getCategoryDetails(int categoryId) async {
    final response = await client.getRequest(Url.categoryById(categoryId));

    if (response.isSuccess &&
        response.responseData != null &&
        response.responseData is Map<String, dynamic>) {
      return Category2Response.fromJson(
        response.responseData as Map<String, dynamic>,
      );
    } else {
      throw Exception(response.errorMessage ?? "Failed to fetch category details");
    }
  }

  /// শুধু চিলড্রেন ক্যাটেগরি লোড করা
  Future<List<Category>> getCategoryChildren(int categoryId) async {
    final response = await client.getRequest(Url.categoryById(categoryId));

    if (response.isSuccess &&
        response.responseData != null &&
        response.responseData is Map<String, dynamic>) {
      final data = response.responseData as Map<String, dynamic>;
      return (data['children'] as List)
          .map((childJson) => Category.fromJson(childJson))
          .toList();
    } else {
      throw Exception(response.errorMessage ?? "Failed to fetch category children");
    }
  }
}