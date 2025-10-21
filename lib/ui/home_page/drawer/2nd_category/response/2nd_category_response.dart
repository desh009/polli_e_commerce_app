// category2_response.dart
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/2nd_category_model/2nd_category_model.dart';

class Category2Response {
  final Category2 category;
  final List<Category2> children;

  Category2Response({
    required this.category,
    required this.children,
  });

  factory Category2Response.fromJson(Map<String, dynamic> json) {
    return Category2Response(
      category: Category2.fromJson(json['category']),
      children: (json['children'] as List)
          .map((childJson) => Category2.fromJson(childJson))
          .toList(),
    );
  }

  // ✅ Helper methods যোগ করুন
  bool get hasChildren => children.isNotEmpty;
  List<Category2> get activeChildren => children.where((c) => c.status == 1).toList();
}