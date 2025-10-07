class Category {
  final int id;
  final String title;
  final int? parentId;
  final String? image;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.title,
    this.parentId,
    this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      parentId: json['parent_id'],
      image: json['image'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "parent_id": parentId,
      "image": image,
      "status": status,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}
