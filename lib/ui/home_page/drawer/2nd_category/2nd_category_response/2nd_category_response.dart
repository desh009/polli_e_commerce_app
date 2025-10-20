
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/response/category_response.dart';

class CategoryDetailsResponse {
  final Category category;
  final List<Category> children;

  CategoryDetailsResponse({
    required this.category,
    required this.children,
  });

  factory CategoryDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CategoryDetailsResponse(
      category: Category.fromJson(json['category']),
      children: (json['children'] as List)
          .map((childJson) => Category.fromJson(childJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category.toJson(),
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}