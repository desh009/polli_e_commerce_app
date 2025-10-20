// import 'package:logger/logger.dart';
// import 'package:polli_e_commerce_app/core/network/api_client.dart';
// import 'package:polli_e_commerce_app/core/network/url/url.dart';
// import 'package:polli_e_commerce_app/core/screen/catergory/product_2_response/response/product_2_response.dart';

// class Product2Repository {
//   final NetworkClient networkClient;
//   final Logger _logger = Logger();

//   Product2Repository({required this.networkClient});

//   // 🔹 সব প্রোডাক্ট লোড
//   Future<List<ProductModel>> fetchAllProducts() async {
//     _logger.i("📦 Fetching all products from → ${Url.productList}");
//     final response = await networkClient.getRequest(Url.productList);

//     _logger.i("📥 Response (fetchAllProducts): ${response.statusCode}");
//     if (response.isSuccess && response.responseData != null) {
//       final List data = response.responseData?['data'] ?? [];
//       _logger.i("✅ Total products fetched: ${data.length}");
//       return data.map((item) => ProductModel.fromJson(item)).toList();
//     } else {
//       _logger.e("❌ Error fetching all products: ${response.errorMessage}");
//       throw Exception(response.errorMessage ?? 'Failed to fetch products');
//     }
//   }

//   // 🔹 আইডি অনুযায়ী প্রোডাক্ট লোড
//   Future<ProductModel> fetchProductById(int id) async {
//     final url = Url.productById(id);
//     _logger.i("🔎 Fetching product by ID → $url");

//     final response = await networkClient.getRequest(url);
//     _logger.i("📥 Response (fetchProductById): ${response.statusCode}");

//     if (response.isSuccess && response.responseData != null) {
//       final data = response.responseData?['product'];
//       if (data == null) {
//         _logger.w("⚠️ No product data found for ID $id");
//         throw Exception('Product not found');
//       }
//       final product = ProductModel.fromJson(data);
//       _logger.i("✅ Product fetched successfully: ${product.title}");
//       return product;
//     } else {
//       _logger.e("❌ Error fetching product by ID $id: ${response.errorMessage}");
//       throw Exception(response.errorMessage ?? 'Failed to fetch product');
//     }
//   }

//   // 🔹 ক্যাটাগরি অনুযায়ী প্রোডাক্ট লোড
//   Future<List<ProductModel>> fetchProductsByCategory(int categoryId) async {
//     final url = "${Url.productList}?category_id=$categoryId";
//     _logger.i("🧩 Fetching products by category → $url");

//     final response = await networkClient.getRequest(url);
//     _logger.i("📥 Response (fetchProductsByCategory): ${response.statusCode}");

//     if (response.isSuccess && response.responseData != null) {
//       final List data = response.responseData?['data'] ?? [];
//       _logger.i("✅ Category $categoryId products fetched: ${data.length}");
//       return data.map((item) => ProductModel.fromJson(item)).toList();
//     } else {
//       _logger.e(
//           "❌ Error fetching category $categoryId products: ${response.errorMessage}");
//       throw Exception(
//           response.errorMessage ?? 'Failed to fetch products by category');
//     }
//   }

//   // 🔹 নতুন প্রোডাক্ট তৈরি
//   Future<ProductModel> createProduct(Map<String, dynamic> body) async {
//     _logger.i("🆕 Creating product with body: $body");

//     final response =
//         await networkClient.postRequest(Url.productList, body: body);

//     _logger.i("📥 Response (createProduct): ${response.statusCode}");
//     if (response.isSuccess && response.responseData != null) {
//       final product = response.responseData?['product'];
//       if (product == null) {
//         _logger.w("⚠️ Product creation failed (no product key in response)");
//         throw Exception('Product creation failed');
//       }
//       final created = ProductModel.fromJson(product);
//       _logger.i("✅ Product created successfully: ${created.title}");
//       return created;
//     } else {
//       _logger.e("❌ Error creating product: ${response.errorMessage}");
//       throw Exception(response.errorMessage ?? 'Failed to create product');
//     }
//   }

//   // 🔹 প্রোডাক্ট আপডেট
//   Future<ProductModel> updateProduct(int id, Map<String, dynamic> body) async {
//     final url = Url.productById(id);
//     _logger.i("✏️ Updating product (ID $id) → $url");
//     _logger.i("🧾 Body: $body");

//     final response = await networkClient.putRequest(url, body: body);
//     _logger.i("📥 Response (updateProduct): ${response.statusCode}");

//     if (response.isSuccess && response.responseData != null) {
//       final product = response.responseData?['product'];
//       if (product == null) {
//         _logger.w("⚠️ Product update failed (no product key in response)");
//         throw Exception('Product update failed');
//       }
//       final updated = ProductModel.fromJson(product);
//       _logger.i("✅ Product updated successfully: ${updated.title}");
//       return updated;
//     } else {
//       _logger.e("❌ Error updating product ID $id: ${response.errorMessage}");
//       throw Exception(response.errorMessage ?? 'Failed to update product');
//     }
//   }

//   // 🔹 প্রোডাক্ট ডিলিট
//   Future<bool> deleteProduct(int id) async {
//     final url = Url.productById(id);
//     _logger.i("🗑️ Deleting product → $url");

//     final response = await networkClient.deleteRequest(url);
//     _logger.i("📥 Response (deleteProduct): ${response.statusCode}");

//     if (response.isSuccess) {
//       _logger.i("✅ Product deleted successfully (ID: $id)");
//       return true;
//     } else {
//       _logger.e("❌ Error deleting product ID $id: ${response.errorMessage}");
//       throw Exception(response.errorMessage ?? 'Failed to delete product');
//     }
//   }
// }
