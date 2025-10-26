// lib/core/models/single_product_model.dart

class SingleProductModel {
  final int id;
  final String title;
  final String image;
  final String categoryId;
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductCategory> categories;

  SingleProductModel({
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

  factory SingleProductModel.fromJson(Map<String, dynamic> json) {
    return SingleProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
      categoryId: json['category_id'] as String,
      brandId: json['brand_id'] as int,
      purchasePrice: json['purchase_price'] as String,
      price: json['price'] as String,
      discount: json['discount'] as String,
      discountPercent: json['discount_percent'] as String,
      discountPrice: json['discount_price'] as String,
      discountType: json['discount_type'] as int,
      unitType: json['unit_type'] as int,
      quantity: json['quantity'] as int,
      sku: json['sku'] as String,
      status: json['status'] as int,
      totalSell: json['total_sell'] as int,
      availability: json['availability'] as int,
      stockable: json['stockable'] as int,
      description: json['description'],
      indoorSerial: json['indoor_serial'] as String,
      outdoorSerial: json['outdoor_serial'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      categories: (json['categories'] as List)
          .map((category) => ProductCategory.fromJson(category))
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }

  // Helper methods
  bool get isInStock => quantity > 0 && availability == 1;
  bool get hasDiscount => double.parse(discount) > 0;
  double get finalPrice => double.parse(price) - double.parse(discountPrice);
  String get formattedPrice => '৳$price';
  String get formattedDiscountPrice => '৳${finalPrice.toStringAsFixed(2)}';
  
  // Fix image URL if needed
  String get fixedImageUrl {
    if (image.contains('https://')) {
      return image;
    } else if (image.startsWith('/storage')) {
      return 'https://inventory.growtech.com.bd$image';
    } else {
      return 'https://inventory.growtech.com.bd/storage/$image';
    }
  }
}

class ProductCategory {
  final int id;
  final String title;
  final int? parentId;
  final String image;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductCategory({
    required this.id,
    required this.title,
    this.parentId,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as int,
      title: json['title'] as String,
      parentId: json['parent_id'],
      image: json['image'] as String,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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

  // Fix category image URL
  String get fixedImageUrl {
    if (image.contains('https://')) {
      return image;
    } else if (image.startsWith('images/')) {
      return 'https://inventory.growtech.com.bd/storage/$image';
    } else {
      return 'https://inventory.growtech.com.bd/storage/images/$image';
    }
  }
}