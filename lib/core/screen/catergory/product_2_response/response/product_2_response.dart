import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/response/category_response.dart';

class Product {
  final int id;
  final String title;
  final String image;
  final String categoryId;
  final int? brandId;
  final double purchasePrice;
  final double price;
  final double discount;
  final double discountPercent;
  final double discountPrice;
  final int? discountType;
  final int? unitType;
  final double quantity;
  final String sku;
  final int status;
  final int totalSell;
  final int availability;
  final int stockable;
  final String? description;
  final String indoorSerial;
  final String outdoorSerial;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Category> categories;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.categoryId,
    this.brandId,
    required this.purchasePrice,
    required this.price,
    required this.discount,
    required this.discountPercent,
    required this.discountPrice,
    this.discountType,
    this.unitType,
    required this.quantity,
    required this.sku,
    required this.status,
    required this.totalSell,
    required this.availability,
    required this.stockable,
    this.description,
    required this.indoorSerial,
    required this.outdoorSerial,
    this.createdAt,
    this.updatedAt,
    required this.categories,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      brandId: json['brand_id'] as int?,
      purchasePrice: _parseDouble(json['purchase_price']),
      price: _parseDouble(json['price']),
      discount: _parseDouble(json['discount']),
      discountPercent: _parseDouble(json['discount_percent']),
      discountPrice: _parseDouble(json['discount_price']),
      discountType: json['discount_type'] as int?,
      unitType: json['unit_type'] as int?,
      quantity: _parseDouble(json['quantity']),
      sku: json['sku'] as String? ?? '',
      status: json['status'] as int? ?? 0,
      totalSell: json['total_sell'] as int? ?? 0,
      availability: json['availability'] as int? ?? 0,
      stockable: json['stockable'] as int? ?? 0,
      description: json['description'] as String?,
      indoorSerial: json['indoor_serial'] as String? ?? '',
      outdoorSerial: json['outdoor_serial'] as String? ?? '',
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((c) => Category.fromJson(c))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'category_id': categoryId,
      'brand_id': brandId,
      'purchase_price': purchasePrice.toString(),
      'price': price.toString(),
      'discount': discount.toString(),
      'discount_percent': discountPercent.toString(),
      'discount_price': discountPrice.toString(),
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'categories': categories.map((c) => c.toJson()).toList(),
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static DateTime? _parseDateTime(dynamic date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      return null;
    }
  }

  // ✅ Useful Getters
  double get profitMargin {
    if (purchasePrice == 0) return 0.0;
    return ((price - purchasePrice) / purchasePrice) * 100;
  }

  bool get isOutOfStock => quantity <= 0;
  
  String get formattedPrice => '৳${price.toStringAsFixed(2)}';
  
  String get formattedDiscount {
    if (discountPercent > 0) return '${discountPercent.toStringAsFixed(1)}% ছাড়';
    if (discountPrice > 0) return '৳${discountPrice.toStringAsFixed(2)} ছাড়';
    return '';
  }

  bool get hasDiscount => discountPrice > 0 || discountPercent > 0;
  
  double get finalPrice {
    if (discountPrice > 0) return price - discountPrice;
    if (discountPercent > 0) return price * (1 - discountPercent / 100);
    return price;
  }

  bool get inStock => availability == 1 && quantity > 0;

  String get firstCategoryName {
    return categories.isNotEmpty ? categories.first.title : '';
  }

  List<int> get categoryIds {
    try {
      return categoryId
          .split('|')
          .where((e) => e.isNotEmpty)
          .map(int.parse)
          .toList();
    } catch (e) {
      return [];
    }
  }

  bool hasCategory(int id) => categoryIds.contains(id);
}