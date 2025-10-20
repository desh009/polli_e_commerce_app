// import 'package:get/get.dart';
// import 'package:logger/logger.dart';
// import 'package:polli_e_commerce_app/core/screen/catergory/product_2_response/response/repository/product_2_repository.dart';
// import 'package:polli_e_commerce_app/core/screen/catergory/product_2_response/response/product_2_response.dart';

// class Product2Controller extends GetxController {
//   final Product2Repository repository;
//   final Logger _logger = Logger();

//   Product2Controller({required this.repository});

//   final RxList<ProductModel> products = <ProductModel>[].obs;
//   final Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   // 🔹 সব প্রোডাক্ট লোড করা
//   Future<void> loadAllProducts() async {
//     _logger.i("📦 Loading all products...");
//     try {
//       isLoading.value = true;
//       final data = await repository.fetchAllProducts();
//       products.assignAll(data);
//       _logger.i("✅ Total products loaded: ${data.length}");
//     } catch (e) {
//       errorMessage.value = e.toString();
//       _logger.e("❌ Failed to load all products: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // 🔹 আইডি দিয়ে প্রোডাক্ট লোড করা
//   Future<void> loadProductById(int id) async {
//     _logger.i("🔎 Loading product by ID: $id");
//     try {
//       isLoading.value = true;
//       final product = await repository.fetchProductById(id);
//       selectedProduct.value = product;
//       _logger.i("✅ Product loaded: ${product.title}");
//     } catch (e) {
//       errorMessage.value = e.toString();
//       _logger.e("❌ Failed to load product by ID $id: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // 🔹 ক্যাটাগরি অনুযায়ী প্রোডাক্ট লোড করা
//   Future<void> loadProductsByCategory(int categoryId) async {
//     _logger.i("🧩 Loading products by category ID: $categoryId");
//     try {
//       isLoading.value = true;
//       final data = await repository.fetchProductsByCategory(categoryId);
//       products.assignAll(data);
//       _logger.i("✅ Category $categoryId → ${data.length} products loaded");
//     } catch (e) {
//       errorMessage.value = e.toString();
//       _logger.e("❌ Failed to load products by category $categoryId: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // 🔹 নতুন প্রোডাক্ট তৈরি
//   Future<void> createProduct(Map<String, dynamic> body) async {
//     _logger.i("🆕 Creating new product...");
//     try {
//       isLoading.value = true;
//       final product = await repository.createProduct(body);
//       products.add(product);
//       _logger.i("✅ Product created: ${product.title}");
//     } catch (e) {
//       errorMessage.value = e.toString();
//       _logger.e("❌ Failed to create product: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // 🔹 প্রোডাক্ট আপডেট
//   Future<void> updateProduct(int id, Map<String, dynamic> body) async {
//     _logger.i("✏️ Updating product (ID $id)...");
//     try {
//       isLoading.value = true;
//       final updated = await repository.updateProduct(id, body);
//       final index = products.indexWhere((p) => p.id == id);
//       if (index != -1) {
//         products[index] = updated;
//         _logger.i("✅ Product updated: ${updated.title}");
//       } else {
//         _logger.w("⚠️ Product not found in list (ID: $id)");
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       _logger.e("❌ Failed to update product ID $id: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // 🔹 প্রোডাক্ট ডিলিট
//   Future<void> deleteProduct(int id) async {
//     _logger.i("🗑️ Deleting product (ID: $id)...");
//     try {
//       isLoading.value = true;
//       final success = await repository.deleteProduct(id);
//       if (success) {
//         products.removeWhere((p) => p.id == id);
//         _logger.i("✅ Product deleted successfully (ID: $id)");
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       _logger.e("❌ Failed to delete product ID $id: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
