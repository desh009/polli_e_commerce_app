// lib/core/models/product_model.dart

class ProductModel {
  final int id;
  final String title;
  final String image;
  final String categoryId; // API তে "|6|" আসে, তাই String রাখা ঠিক আছে ✅
  final int brandId;
  final String purchasePrice;
  final String price;
  final String discount;
  final String discountPercent;
  final String discountPrice;
  final int discountType;
  final int unitType;
  final int quantity;
  final String sku;
  final int status;
  final int totalSell;
  final int availability;
  final int stockable;
  final String? description;
  final String indoorSerial;
  final String outdoorSerial;
  final String createdAt;
  final String updatedAt;
  final List<Category> categories;

  ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.categoryId,
    required this.brandId,
    required this.purchasePrice,
    required this.price,
    required this.discount,
    required this.discountPercent,
    required this.discountPrice,
    required this.discountType,
    required this.unitType,
    required this.quantity,
    required this.sku,
    required this.status,
    required this.totalSell,
    required this.availability,
    required this.stockable,
    this.description,
    required this.indoorSerial,
    required this.outdoorSerial,
    required this.createdAt,
    required this.updatedAt,
    required this.categories,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      categoryId: json['category_id']?.toString() ?? '', // ✅ fixed (ensure string)
      brandId: json['brand_id'] ?? 0,
      purchasePrice: json['purchase_price'] ?? '0.00',
      price: json['price'] ?? '0.00',
      discount: json['discount'] ?? '0.00',
      discountPercent: json['discount_percent'] ?? '0.00',
      discountPrice: json['discount_price'] ?? '0.00',
      discountType: json['discount_type'] ?? 0,
      unitType: json['unit_type'] ?? 0,
      quantity: json['quantity'] ?? 0,
      sku: json['sku'] ?? '',
      status: json['status'] ?? 0,
      totalSell: json['total_sell'] ?? 0,
      availability: json['availability'] ?? 0,
      stockable: json['stockable'] ?? 0,
      description: json['description'],
      indoorSerial: json['indoor_serial'] ?? '',
      outdoorSerial: json['outdoor_serial'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      categories: (json['categories'] as List? ?? [])
          .map((category) => Category.fromJson(category))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'category_id': categoryId,
      'brand_id': brandId,
      'purchase_price': purchasePrice,
      'price': price,
      'discount': discount,
      'discount_percent': discountPercent,
      'discount_price': discountPrice,
      'discount_type': discountType,
      'unit_type': unitType,
      'quantity': quantity,
      'sku': sku,
      'status': status,
      'total_sell': totalSell,
      'availability': availability,
      'stockable': stockable,
      'description': description,
      'indoor_serial': indoorSerial,
      'outdoor_serial': outdoorSerial,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }

  // ✅ Helper methods
  double get finalPrice {
    final basePrice = double.tryParse(price) ?? 0.0;
    final discountValue = double.tryParse(discountPrice) ?? 0.0;
    return basePrice - discountValue;
  }

  bool get hasDiscount => (double.tryParse(discountPrice) ?? 0.0) > 0;

  bool get inStock => quantity > 0 && availability == 1;

  String get formattedPrice => '৳$price';

  String get formattedFinalPrice => '৳${finalPrice.toStringAsFixed(2)}';

  String get imageUrl => image; // ✅ image already has full URL

  // ✅ category_id like "|6|" → [6]
  List<int> get parsedCategoryIds {
    try {
      if (categoryId.contains('|')) {
        return categoryId
            .split('|')
            .where((part) => part.isNotEmpty)
            .map((part) => int.tryParse(part) ?? 0)
            .where((id) => id > 0)
            .toList();
      } else {
        final id = int.tryParse(categoryId) ?? 0;
        return id > 0 ? [id] : [];
      }
    } catch (_) {
      return [];
    }
  }

  Category? get primaryCategory =>
      categories.isNotEmpty ? categories.first : null;

  String get unitTypeText {
    switch (unitType) {
      case 2:
        return 'গ্রাম';
      case 8:
        return 'লিটার';
      default:
        return 'পিস';
    }
  }
}

class Category {
  final int id;
  final String title;
  final int parentId;
  final String image;
  final int status;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.title,
    required this.parentId,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      parentId: json['parent_id'] ?? 0,
      image: json['image'] ?? '',
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'parent_id': parentId,
      'image': image,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // ✅ image path fix
  String get imageUrl {
    if (image.startsWith('http')) return image;
    return 'https://inventory.growtech.com.bd/${image.startsWith('/') ? image.substring(1) : image}';
  }
}
