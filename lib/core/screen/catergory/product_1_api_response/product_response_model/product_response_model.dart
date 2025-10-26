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
//   final List<Category> categories;

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
//       purchasePrice: double.tryParse(json['purchase_price']?.toString() ?? '0') ?? 0.0,
//       price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
//       discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,
//       discountPercent: double.tryParse(json['discount_percent']?.toString() ?? '0') ?? 0.0,
//       discountPrice: double.tryParse(json['discount_price']?.toString() ?? '0') ?? 0.0,
//       discountType: json['discount_type'] ?? 1,
//       unitType: json['unit_type'] ?? 2,
//       quantity: json['quantity'] ?? 0,
//       sku: json['sku'] ?? '',
//       status: json['status'] ?? 1,
//       totalSell: json['total_sell'] ?? 0,
//       availability: json['availability'] ?? 1,
//       stockable: json['stockable'] ?? 1,
//       description: json['description'],
//       indoorSerial: json['indoor_serial'] ?? '',
//       outdoorSerial: json['outdoor_serial'] ?? '',
//       createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
//       updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
//       categories: (json['categories'] as List)
//           .map((item) => Category.fromJson(item))
//           .toList(),
//     );
//   }

//   // ✅ toJson মেথড যোগ করুন
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'image': image,
//       'category_id': categoryId,
//       'brand_id': brandId,
//       'purchase_price': purchasePrice,
//       'price': price,
//       'discount': discount,
//       'discount_percent': discountPercent,
//       'discount_price': discountPrice,
//       'discount_type': discountType,
//       'unit_type': unitType,
//       'quantity': quantity,
//       'sku': sku,
//       'status': status,
//       'total_sell': totalSell,
//       'availability': availability,
//       'stockable': stockable,
//       'description': description,
//       'indoor_serial': indoorSerial,
//       'outdoor_serial': outdoorSerial,
//       'created_at': createdAt.toIso8601String(),
//       'updated_at': updatedAt.toIso8601String(),
//       'categories': categories.map((category) => category.toJson()).toList(),
//     };
//   }

//   // Helper getters for your UI
//   String get imageUrl => image;
  
//   double get finalPrice {
//     return discountPrice > 0 ? discountPrice : price;
//   }
  
//   bool get hasDiscount => discountPrice > 0 && discountPrice != price;
  
//   String get formattedPrice => '৳${price.toStringAsFixed(2)}';
  
//   String get formattedFinalPrice => '৳${finalPrice.toStringAsFixed(2)}';
  
//   bool get inStock => availability == 1 && quantity > 0;
  
//   String get unitTypeText {
//     switch (unitType) {
//       case 1: return 'পিস';
//       case 2: return 'গ্রাম';
//       case 3: return 'কেজি';
//       default: return 'পিস';
//     }
//   }
  
//   Category? get primaryCategory => categories.isNotEmpty ? categories.first : null;
// }

// class Category {
//   final int id;
//   final String title;
//   final int parentId;
//   final String image;
//   final int status;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   Category({
//     required this.id,
//     required this.title,
//     required this.parentId,
//     required this.image,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['id'] ?? 0,
//       title: json['title'] ?? '',
//       parentId: json['parent_id'] ?? 0,
//       image: json['image'] ?? '',
//       status: json['status'] ?? 1,
//       createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
//       updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
//     );
//   }

//   // ✅ Category এর জন্যও toJson মেথড যোগ করুন
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'parent_id': parentId,
//       'image': image,
//       'status': status,
//       'created_at': createdAt.toIso8601String(),
//       'updated_at': updatedAt.toIso8601String(),
//     };
//   }
// }

// class Link {
//   final String? url;
//   final String label;
//   final bool active;

//   Link({
//     this.url,
//     required this.label,
//     required this.active,
//   });

//   factory Link.fromJson(Map<String, dynamic> json) {
//     return Link(
//       url: json['url'],
//       label: json['label'] ?? '',
//       active: json['active'] ?? false,
//     );
//   }

//   // ✅ Link এর জন্যও toJson মেথড যোগ করুন
//   Map<String, dynamic> toJson() {
//     return {
//       'url': url,
//       'label': label,
//       'active': active,
//     };
//   }
// }

// class ProductResponse {
//   final String category;
//   final Products products;

//   ProductResponse({
//     required this.category,
//     required this.products,
//   });

//   factory ProductResponse.fromJson(Map<String, dynamic> json) {
//     return ProductResponse(
//       category: json['category'] ?? '',
//       products: Products.fromJson(json['products']),
//     );
//   }

//   // ✅ ProductResponse এর জন্যও toJson মেথড
//   Map<String, dynamic> toJson() {
//     return {
//       'category': category,
//       'products': products.toJson(),
//     };
//   }
// }

// class Products {
//   final int currentPage;
//   final List<ProductModel> data;
//   final String firstPageUrl;
//   final int from;
//   final int lastPage;
//   final String lastPageUrl;
//   final List<Link> links;
//   final String? nextPageUrl;
//   final String path;
//   final int perPage;
//   final String? prevPageUrl;
//   final int to;
//   final int total;

//   Products({
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

//   factory Products.fromJson(Map<String, dynamic> json) {
//     return Products(
//       currentPage: json['current_page'] ?? 1,
//       data: (json['data'] as List)
//           .map((item) => ProductModel.fromJson(item))
//           .toList(),
//       firstPageUrl: json['first_page_url'] ?? '',
//       from: json['from'] ?? 0,
//       lastPage: json['last_page'] ?? 1,
//       lastPageUrl: json['last_page_url'] ?? '',
//       links: (json['links'] as List)
//           .map((item) => Link.fromJson(item))
//           .toList(),
//       nextPageUrl: json['next_page_url'],
//       path: json['path'] ?? '',
//       perPage: json['per_page'] ?? 15,
//       prevPageUrl: json['prev_page_url'],
//       to: json['to'] ?? 0,
//       total: json['total'] ?? 0,
//     );
//   }

//   // ✅ Products এর জন্যও toJson মেথড
//   Map<String, dynamic> toJson() {
//     return {
//       'current_page': currentPage,
//       'data': data.map((item) => item.toJson()).toList(),
//       'first_page_url': firstPageUrl,
//       'from': from,
//       'last_page': lastPage,
//       'last_page_url': lastPageUrl,
//       'links': links.map((item) => item.toJson()).toList(),
//       'next_page_url': nextPageUrl,
//       'path': path,
//       'per_page': perPage,
//       'prev_page_url': prevPageUrl,
//       'to': to,
//       'total': total,
//     };
//   }
// }