// lib/core/controllers/product_detail_controller.dart

import 'package:get/get.dart';

import 'package:polli_e_commerce_app/core/screen/catergory/product_2_response/response/product_2_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_2_response/response/repository/product_2_repository.dart';

class ProductDetailController extends GetxController {
  final BaseProductDetailRepository _repository;

  ProductDetailController({required BaseProductDetailRepository repository})
      : _repository = repository;

  // State
  final product = Rxn<SingleProductModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Getters
  bool get hasProduct => product.value != null;
  bool get hasError => errorMessage.value.isNotEmpty;
  SingleProductModel? get currentProduct => product.value;

  @override
  void onInit() {
    super.onInit();
    // Don't auto-load, let screens control when to load
  }

  // Load product details
  Future<void> loadProductDetail(int productId) async {
    if (isLoading.value) return;
    
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final productDetail = await _repository.getProductDetail(productId);
      product.value = productDetail;
      print('✅ Product loaded successfully: ${productDetail.title}');
    } catch (e) {
      errorMessage.value = 'Failed to load product: ${e.toString()}';
      print('❌ Error loading product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh product data
  Future<void> refreshProduct(int productId) async {
    await loadProductDetail(productId);
  }

  // Clear current product
  void clearProduct() {
    product.value = null;
    errorMessage.value = '';
  }

  // Check if product is in stock
  bool get isProductInStock {
    return product.value?.isInStock ?? false;
  }

  // Get final price with discount
  String get displayPrice {
    final currentProduct = product.value;
    if (currentProduct == null) return '৳0.00';
    
    return currentProduct.hasDiscount 
        ? currentProduct.formattedDiscountPrice
        : currentProduct.formattedPrice;
  }

  // Get main category name
  String get mainCategoryName {
    final categories = product.value?.categories;
    if (categories == null || categories.isEmpty) return '';
    return categories.first.title;
  }

  @override
  void onClose() {
    clearProduct();
    super.onClose();
  }
}