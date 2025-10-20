// lib/core/screen/catergory/product_1_api_response/response/controller/product_1_controller.dart

import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/product_1_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/repository/product_1_repository.dart';

class ProductController extends GetxController {
  final ProductRepository repository;

  // ✅ Fix constructor
  ProductController(this.repository);

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> loadAllProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await repository.fetchAllProducts();
      products.assignAll(data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadProductsByCategory(int categoryId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await repository.fetchAllProducts(); // সব products fetch

      // 🟢 Filter products by category (parent + sub-category)
      final filtered = data.where((p) {
        // category ids from "|6|"
        final ids = p.categoryId
            .split('|')
            .where((e) => e.isNotEmpty)
            .map(int.parse)
            .toList();

        // parent category match
        // check sub-category parent_id too
        final hasParent = p.categories.any((c) => c.parentId == categoryId);

        return ids.contains(categoryId) || hasParent;
      }).toList();

      products.assignAll(filtered);
      print('✅ Loaded ${filtered.length} products for category ID $categoryId');
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
