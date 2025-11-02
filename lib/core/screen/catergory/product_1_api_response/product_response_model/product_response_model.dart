// import 'dart:convert';

// class ProductApiResponse {
//   final String category;
//   final ProductList products;

//   ProductApiResponse({
//     required this.category,
//     required this.products,
//   });

//   factory ProductApiResponse.fromJson(Map<String, dynamic> json) {
//     return ProductApiResponse(
//       category: json['category'] ?? '',
//       products: ProductList.fromJson(json['products']),
//     );
//   }
// }

// class ProductList {
//   final int currentPage;
//   final List<ProductModel> data;
//   final String firstPageUrl;
//   final int from;
//   final int lastPage;
//   final String lastPageUrl;
//   final List<PaginationLink> links;
//   final String? nextPageUrl;
//   final String path;
//   final int perPage;
//   final String? prevPageUrl;
//   final int to;
//   final int total;

//   ProductList({
//     required this.currentPage,
//     required this.data,
//     required this.firstPageUrl,
//     required this.from,
//     required this.lastPage,
//     required this.lastPageUrl,
//     required this.links,
//     this.nextPageUrl,
//     required this.path,
//     required this.perPage,
//     this.prevPageUrl,
//     required this.to,
//     required this.total,
//   });

//   factory ProductList.fromJson(Map<String, dynamic> json) {
//     return ProductList(
//       currentPage: json['current_page'] ?? 1,
//       data: (json['data'] as List<dynamic>?)
//               ?.map((item) => ProductModel.fromJson(item))
//               .toList() ??
//           [],
//       firstPageUrl: json['first_page_url'] ?? '',
//       from: json['from'] ?? 0,
//       lastPage: json['last_page'] ?? 1,
//       lastPageUrl: json['last_page_url'] ?? '',
//       links: (json['links'] as List<dynamic>?)
//               ?.map((item) => PaginationLink.fromJson(item))
//               .toList() ??
//           [],
//       nextPageUrl: json['next_page_url'],
//       path: json['path'] ?? '',
//       perPage: json['per_page'] ?? 15,
//       prevPageUrl: json['prev_page_url'],
//       to: json['to'] ?? 0,
//       total: json['total'] ?? 0,
//     );
//   }
// }

// class ProductModel {
//   final int id;
//   final String title;
//   final String image;
//   final String categoryId;
//   final int brandId;
//   final double purchasePrice;
//   final double price;
//   final double discount;
//   final double discountPercent;
//   final double discountPrice;
//   final int discountType;
//   final int unitType;
//   final int quantity;
//   final String sku;
//   final int status;
//   final int totalSell;
//   final int availability;
//   final int stockable;
//   final String? description;
//   final String indoorSerial;
//   final String outdoorSerial;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final List<ProductCategory> categories;

//   ProductModel({
//     required this.id,
//     required this.title,
//     required this.image,
//     required this.categoryId,
//     required this.brandId,
//     required this.purchasePrice,
//     required this.price,
//     required this.discount,
//     required this.discountPercent,
//     required this.discountPrice,
//     required this.discountType,
//     required this.unitType,
//     required this.quantity,
//     required this.sku,
//     required this.status,
//     required this.totalSell,
//     required this.availability,
//     required this.stockable,
//     this.description,
//     required this.indoorSerial,
//     required this.outdoorSerial,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.categories,
//   });

//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       id: json['id'] ?? 0,
//       title: json['title'] ?? '',
//       image: json['image'] ?? '',
//       categoryId: json['category_id'] ?? '',
//       brandId: json['brand_id'] ?? 0,
//       purchasePrice: _parseDouble(json['purchase_price']),
//       price: _parseDouble(json['price']),
//       discount: _parseDouble(json['discount']),
//       discountPercent: _parseDouble(json['discount_percent']),
//       discountPrice: _parseDouble(json['discount_price']),
//       discountType: json['discount_type'] ?? 0,
//       unitType: json['unit_type'] ?? 0,
//       quantity: json['quantity'] ?? 0,
//       sku: json['sku'] ?? '',
//       status: json['status'] ?? 0,
//       totalSell: json['total_sell'] ?? 0,
//       availability: json['availability'] ?? 0,
//       stockable: json['stockable'] ?? 0,
//       description: json['description'],
//       indoorSerial: json['indoor_serial'] ?? '',
//       outdoorSerial: json['outdoor_serial'] ?? '',
//       createdAt: _parseDateTime(json['created_at']),
//       updatedAt: _parseDateTime(json['updated_at']),
//       categories: (json['categories'] as List<dynamic>?)
//               ?.map((item) => ProductCategory.fromJson(item))
//               .toList() ??
//           [],
//     );
//   }

//   // Helper Methods
//   double get finalPrice => discountPrice > 0 ? discountPrice : price;
  
//   bool get hasDiscount => discountPrice > 0 && discountPrice < price;
  
//   bool get isInStock => availability == 1 && quantity > 0;
  
//   String get unitText {
//     switch (unitType) {
//       case 2:
//         return '$quantity গ্রাম';
//       default:
//         return '$quantity পিস';
//     }
//   }
  
//   String get categoryName => categories.isNotEmpty ? categories.first.title : '';
  
//   // For backward compatibility with old code
//   String get imageUrl => image;
//   bool get inStock => isInStock;
//   String get unitTypeText => unitText;
//   String get formattedPrice => '৳${price.toStringAsFixed(2)}';
//   String get formattedFinalPrice => '৳${finalPrice.toStringAsFixed(2)}';
//   ProductCategory? get primaryCategory => categories.isNotEmpty ? categories.first : null;

//   static double _parseDouble(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value) ?? 0.0;
//     return 0.0;
//   }

//   static DateTime _parseDateTime(dynamic value) {
//     if (value == null) return DateTime.now();
//     if (value is DateTime) return value;
//     if (value is String) {
//       try {
//         return DateTime.parse(value);
//       } catch (e) {
//         return DateTime.now();
//       }
//     }
//     return DateTime.now();
//   }
// }

// class ProductCategory {
//   final int id;
//   final String title;
//   final int parentId;
//   final String image;
//   final int status;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   ProductCategory({
//     required this.id,
//     required this.title,
//     required this.parentId,
//     required this.image,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory ProductCategory.fromJson(Map<String, dynamic> json) {
//     return ProductCategory(
//       id: json['id'] ?? 0,
//       title: json['title'] ?? '',
//       parentId: json['parent_id'] ?? 0,
//       image: json['image'] ?? '',
//       status: json['status'] ?? 0,
//       createdAt: ProductModel._parseDateTime(json['created_at']),
//       updatedAt: ProductModel._parseDateTime(json['updated_at']),
//     );
//   }
// }

// class PaginationLink {
//   final String? url;
//   final String label;
//   final bool active;

//   PaginationLink({
//     this.url,
//     required this.label,
//     required this.active,
//   });

//   factory PaginationLink.fromJson(Map<String, dynamic> json) {
//     return PaginationLink(
//       url: json['url'],
//       label: json['label'] ?? '',
//       active: json['active'] ?? false,
//     );
//   }
// }