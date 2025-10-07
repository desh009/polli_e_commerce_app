class SubCategory {
  final int id;
  final String title;
  final int? parentId;
  final String? image;
  final int status;
  final String createdAt;
  final String updatedAt;

  SubCategory({
    required this.id,
    required this.title,
    this.parentId,
    this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      title: json['title'],
      parentId: json['parent_id'],
      image: json['image'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class SubCategoryResponse {
  final SubCategory category;
  final List<SubCategory> children;

  SubCategoryResponse({
    required this.category,
    required this.children,
  });

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryResponse(
      category: SubCategory.fromJson(json['category']),
      children: (json['children'] as List)
          .map((child) => SubCategory.fromJson(child))
          .toList(),
    );
  }
}
