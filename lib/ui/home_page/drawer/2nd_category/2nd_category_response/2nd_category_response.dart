
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/response/category_response.dart';

class Category2Response {
  final Category category;
  final List<Category> children;

  Category2Response({
    required this.category,
    required this.children,
  });

  factory Category2Response.fromJson(Map<String, dynamic> json) {
    return Category2Response(
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