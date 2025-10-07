import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:polli_e_commerce_app/core/network/url/url.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/2nd_category_response/2nd_category_response.dart';

class SubCategoryRepository {
  Future<SubCategoryResponse> getCategoryById(int id) async {
    final url = "${Url.baseUrl}/api/category/$id";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return SubCategoryResponse.fromJson(jsonData);
    } else {
      throw Exception("Failed to load subcategory");
    }
  }
}
