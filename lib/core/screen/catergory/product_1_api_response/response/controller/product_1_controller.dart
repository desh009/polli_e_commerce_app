import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/product_api_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/repository/product_1_repository.dart';

class ProductController extends GetxController {
  final BaseProductRepository _repository;

  ProductController({required BaseProductRepository repository})
      : _repository = repository;

  // State
  final products = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final selectedProduct = Rxn<ProductModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;
  final currentCategory = ''.obs;
  
  // New: Track loading states separately
  final isInitialLoad = true.obs;
  final isCategoryLoading = false.obs;

  // Getters
  List<ProductModel> get allProducts => products;
  bool get hasProducts => products.isNotEmpty;
  bool get hasError => errorMessage.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    // Don't auto-load, let screens control when to load
  }

  // Load all products with better error handling
  Future<void> loadAllProducts({bool forceRefresh = false}) async {
    // If already loading, return
    if (isLoading.value && !forceRefresh) return;
    
    // If data exists and not forcing refresh, return
    if (products.isNotEmpty && !forceRefresh) return;
    
    _setLoading(true);
    errorMessage.value = '';
    isInitialLoad.value = true;

    try {
      final fetchedProducts = await _repository.getAllProducts();
      products.assignAll(fetchedProducts);
      filteredProducts.assignAll(fetchedProducts);
      isInitialLoad.value = false;
    } catch (e) {
      errorMessage.value = 'Failed to load products: ${e.toString()}';
      isInitialLoad.value = false;
    } finally {
      _setLoading(false);
    }
  }

  // Load products by category with better state management
  Future<void> loadProductsByCategory(int categoryId, {String? categoryName}) async {
    // Prevent duplicate calls for same category
    if (isCategoryLoading.value && currentCategory.value == categoryName) return;
    
    isCategoryLoading.value = true;
    errorMessage.value = '';
    
    if (categoryName != null) {
      currentCategory.value = categoryName;
    }

    try {
      final fetchedProducts = await _repository.getProductsByCategory(categoryId);
      products.assignAll(fetchedProducts);
      filteredProducts.assignAll(fetchedProducts);
      searchQuery.value = ''; // Clear search when changing category
    } catch (e) {
      errorMessage.value = 'Failed to load category products: ${e.toString()}';
    } finally {
      isCategoryLoading.value = false;
    }
  }

  // Get product by ID with cache check
  Future<void> getProductById(int productId) async {
    // Check if product already in list
    final existingProduct = products.firstWhereOrNull(
      (product) => product.id == productId
    );
    
    if (existingProduct != null) {
      selectedProduct.value = existingProduct;
      return;
    }

    _setLoading(true);
    errorMessage.value = '';

    try {
      final product = await _repository.getProductById(productId);
      selectedProduct.value = product;
      
      // Add to products list if not exists
      if (!products.any((p) => p.id == product?.id)) {
        products.add(product!);
      }
    } catch (e) {
      errorMessage.value = 'Failed to load product: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Search products with local filtering first
  Future<void> searchProducts(String query) async {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
      return;
    }

    // First try local filtering
    final localResults = products.where((product) =>
      product.title.toLowerCase().contains(query.toLowerCase()) ||
      (product.description?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();

    if (localResults.isNotEmpty) {
      filteredProducts.assignAll(localResults);
      return;
    }

    // If no local results, try API search
    _setLoading(true);
    try {
      final searchResults = await _repository.searchProducts(query);
      filteredProducts.assignAll(searchResults);
    } catch (e) {
      errorMessage.value = 'Search failed: ${e.toString()}';
      // Fallback to local results even if empty
      filteredProducts.assignAll(localResults);
    } finally {
      _setLoading(false);
    }
  }

  // Filter products by availability
  void filterByAvailability(bool inStockOnly) {
    if (inStockOnly) {
      filteredProducts.assignAll(
        products.where((product) => product.isInStock).toList()
      );
    } else {
      filteredProducts.assignAll(products);
    }
  }

  // Clear all filters and search
  void clearAll() {
    filteredProducts.assignAll(products);
    searchQuery.value = '';
    currentCategory.value = '';
    errorMessage.value = '';
  }

  // Refresh data
  Future<void> refreshData() async {
    if (currentCategory.value.isNotEmpty) {
      // Find category ID from current products or need to implement
      await loadAllProducts(forceRefresh: true);
    } else {
      await loadAllProducts(forceRefresh: true);
    }
  }

  // Check if data needs loading
  bool shouldLoadData() {
    return products.isEmpty && !isLoading.value && !isInitialLoad.value;
  }

  // Private method to set loading state
  void _setLoading(bool loading) {
    isLoading.value = loading;
  }

  // Dispose controller properly
  @override
  void onClose() {
    products.clear();
    filteredProducts.clear();
    selectedProduct.value = null;
    super.onClose();
  }
}