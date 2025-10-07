class Category2nd {
  final int id;
  final String title;
  final int? parentId;
  final String? image;
  final int status;
  final String createdAt;
  final String updatedAt;

  Category2nd({
    required this.id,
    required this.title,
    this.parentId,
    this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category2nd.fromJson(Map<String, dynamic> json) {
    return Category2nd(
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

class Category2Response {
  final Category2nd category;
  final List<Category2nd> children;

  Category2Response({
    required this.category,
    required this.children,
  });

  factory Category2Response.fromJson(Map<String, dynamic> json) {
    return Category2Response(
      category: Category2nd.fromJson(json['category']),
      children: (json['children'] as List)
          .map((child) => Category2nd.fromJson(child))
          .toList(),
    );
  }
}
