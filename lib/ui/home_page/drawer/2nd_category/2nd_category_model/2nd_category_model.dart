// category2_model.dart
class Category2 {
  final int id;
  final String title;
  final int? parentId;
  final String? image;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category2({
    required this.id,
    required this.title,
    this.parentId,
    this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category2.fromJson(Map<String, dynamic> json) {
    return Category2(
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
      'id': id,
      'title': title,
      'parent_id': parentId,
      'image': image,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // ✅ FIXED: hasImage with null safety
  String get imageUrl {
    if (image == null) return '';
    if (image!.startsWith('http')) return image!;
    return 'https://inventory.growtech.com.bd/${image!.startsWith('/') ? image!.substring(1) : image}';
  }

  // ✅ FIXED: hasImage with null safety
  bool get hasImage => image != null && image!.isNotEmpty;
  
  // ✅ isActive getter
  bool get isActive => status == 1;
  
  // ✅ Additional helpful getters
  bool get isParent => parentId == null;
  bool get isChild => parentId != null;
  
  // ✅ Format created date
  String get formattedCreatedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
  
  // ✅ Format updated date  
  String get formattedUpdatedDate {
    return '${updatedAt.day}/${updatedAt.month}/${updatedAt.year}';
  }
}