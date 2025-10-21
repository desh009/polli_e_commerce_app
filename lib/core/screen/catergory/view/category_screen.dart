import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/controller/category_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/response/category_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/controller/product_1_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/product_1_response.dart' hide Category;
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/repository/product_1_repository.dart';
import 'package:polli_e_commerce_app/core/screen/product_screen.dart';
import 'package:polli_e_commerce_app/core/widgets/auth_controller.dart';
import 'package:polli_e_commerce_app/core/screen/filter_bottom_sheet_screen.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/2nd_category_model/2nd_category_model.dart';

// ✅ Category2 Controller import
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/controller/2nd_category_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/repository/2nd_category_repository.dart';

class CategoryScreen extends StatefulWidget {
  final String? initialSelectedOption;
  final String? initialSelectedCategory;

  const CategoryScreen({
    super.key,
    this.initialSelectedCategory,
    this.initialSelectedOption,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late final Category1Controller categoryController;
  late final CartController cartController;
  late final ProductController productController;
  late final Category2Controller category2Controller; // ✅ শুধু Category2Controller

  // Reactive panels
  var showSortPanel = false.obs;
  var showFilterPanel = false.obs;
  var selectedSort = "Price Low to High".obs;

  // ✅ Dynamic Category Mapping
  final RxMap<String, int> categoryNameToId = <String, int>{}.obs;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupCategoryMapping();

    print('🔄 CategoryScreen initialized with Category2Controller');

    // Observe category changes from Category1Controller
    ever(categoryController.currentCategory, (String category) {
      if (category.isNotEmpty) {
        print('🎯 Category changed to: $category');
        _loadProductsForCategory(category);
        _loadCategoryDetails(category);
      }
    });

    // ✅ Category2Controller changes observe করুন
    ever(category2Controller.selectedCategory, (Category2? selectedCategory) {
      if (selectedCategory != null) {
        print('🎯 Category2 selection changed: ${selectedCategory.title}');
        _syncCategoryMappingFromCategory2();
      }
    });

    // Initial category load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialCategory = widget.initialSelectedCategory ?? '';
      if (initialCategory.isNotEmpty) {
        print('🚀 Initial category: $initialCategory');
        _handleInitialCategory(initialCategory);
      } else {
        // Default category
        categoryController.updateCategory('মসলা', null);
      }
    });
  }

  void _initializeControllers() {
    // Category1 Controller
    if (Get.isRegistered<Category1Controller>()) {
      categoryController = Get.find<Category1Controller>();
    } else {
      categoryController = Get.put(Category1Controller(Get.find()), permanent: true);
    }

    // Cart Controller
    if (Get.isRegistered<CartController>()) {
      cartController = Get.find<CartController>();
    } else {
      cartController = Get.put(CartController(), permanent: true);
    }

    // Product Controller
    if (Get.isRegistered<ProductController>()) {
      productController = Get.find<ProductController>();
    } else {
      final repository = ProductRepository(Get.find<NetworkClient>());
      productController = Get.put(
        ProductController(repository: repository),
        permanent: true,
      );
    }

    // ✅ Category2 Controller - শুধু এই controller টি
    if (Get.isRegistered<Category2Controller>()) {
      category2Controller = Get.find<Category2Controller>();
    } else {
      final repository = Category2Repository(Get.find<NetworkClient>());
      category2Controller = Get.put(Category2Controller(repository), permanent: true);
    }
  }

  /// ✅ Dynamic Category Mapping Setup
  void _setupCategoryMapping() {
    // Observe categories from Category1Controller
    ever(categoryController.categories, (List<Category> categories) {
      _updateCategoryMappingFromCategory1(categories);
    } as WorkerCallback<List<Category>>);

    // Observe children from Category2Controller
    ever(category2Controller.childrenCategories, (List<Category2> children) {
      _syncCategoryMappingFromCategory2();
    });

    // Initial sync from existing data
    _updateCategoryMappingFromCategory1(categoryController.categories);
    _syncCategoryMappingFromCategory2();
  }

  /// ✅ Update Mapping from Category1Controller
  void _updateCategoryMappingFromCategory1(List<Category> categories) {
    categoryNameToId.clear();
    
    for (var category in categories) {
      categoryNameToId[category.title] = category.id;
      print('🗺️ [Category1] Added to mapping: ${category.title} -> ${category.id}');
    }
    
    print('📊 Total categories in mapping: ${categoryNameToId.length}');
  }

  /// ✅ Update Mapping from Category2Controller
  void _syncCategoryMappingFromCategory2() {
    if (category2Controller.hasCategory) {
      // Add parent category from Category2
      final parentCategory = category2Controller.parentCategory;
      if (parentCategory != null) {
        categoryNameToId[parentCategory.title] = parentCategory.id;
        print('🗺️ [Category2] Added parent: ${parentCategory.title} -> ${parentCategory.id}');
      }
      
      // Add children categories from Category2
      for (var child in category2Controller.allChildren) {
        categoryNameToId[child.title] = child.id;
        print('🗺️ [Category2] Added child: ${child.title} -> ${child.id}');
      }
      
      print('📊 Updated mapping from Category2. Total: ${categoryNameToId.length}');
    }
  }

  /// ✅ Get Category ID by Name (Dynamic - সব সোর্স চেক করে)
  int? _getCategoryIdByName(String categoryName) {
    // First check in our dynamic mapping
    if (categoryNameToId.containsKey(categoryName)) {
      final id = categoryNameToId[categoryName];
      print('🎯 Found in dynamic mapping: $categoryName -> $id');
      return id;
    }

    // Fallback to Category1Controller
    final idFromController = categoryController.getCategoryIdByName(categoryName);
    if (idFromController != null) {
      print('🎯 Found in Category1Controller: $categoryName -> $idFromController');
      // Add to our mapping for future use
      categoryNameToId[categoryName] = idFromController;
      return idFromController;
    }

    // Fallback to Category2Controller
    final idFromCategory2 = category2Controller.getCategoryIdByName(categoryName);
    if (idFromCategory2 != null) {
      print('🎯 Found in Category2Controller: $categoryName -> $idFromCategory2');
      categoryNameToId[categoryName] = idFromCategory2;
      return idFromCategory2;
    }

    print('❌ Category ID not found for: $categoryName');
    return null;
  }

  void _handleInitialCategory(String categoryName) {
    final categoryId = _getCategoryIdByName(categoryName);
    
    if (categoryId != null) {
      print('✅ Found category: $categoryName (ID: $categoryId)');
      categoryController.updateCategory(categoryName, widget.initialSelectedOption);
      productController.loadProductsByCategory(categoryId);
      _loadCategoryDetails(categoryName);
    } else {
      print('❌ Category not found: $categoryName');
      Get.snackbar(
        'ত্রুটি',
        '$categoryName ক্যাটেগরির জন্য আইডি পাওয়া যায়নি',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      
      // Fallback to default category
      categoryController.updateCategory('মসলা', null);
    }
  }

  void _loadProductsForCategory(String category) {
    print('🔄 Loading products for category: $category');
    
    final categoryId = _getCategoryIdByName(category);
    
    if (categoryId != null) {
      print('✅ Using category ID: $categoryId');
      productController.loadProductsByCategory(categoryId);
    } else {
      print('❌ Category ID not found for: $category');
      Get.snackbar(
        'ত্রুটি',
        '$category ক্যাটেগরির জন্য আইডি পাওয়া যায়নি',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  /// ✅ Category Details লোড করা - Category2Controller দিয়ে
  void _loadCategoryDetails(String category) {
    final categoryId = _getCategoryIdByName(category);
    if (categoryId != null) {
      print('🎯 Loading category details for: $category (ID: $categoryId)');
      
      // Load in Category2Controller
      category2Controller.loadCategoryDetails(categoryId);
    } else {
      print('❌ No category ID found for category details: $category');
    }
  }

  List<ProductModel> applySort(List<ProductModel> products) {
    List<ProductModel> sortedList = List.from(products);
    switch (selectedSort.value) {
      case "Newest First":
        sortedList.sort((a, b) => b.id.compareTo(a.id));
        break;
      case "Name A to Z":
        sortedList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case "Name Z to A":
        sortedList.sort((a, b) => b.title.compareTo(a.title));
        break;
      case "Price High to Low":
        sortedList.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
        break;
      case "Price Low to High":
        sortedList.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
        break;
    }
    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      "Newest First",
      "Name A to Z",
      "Name Z to A",
      "Price High to Low",
      "Price Low to High",
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Obx(() => Text(
              categoryController.currentCategory.value.isEmpty
                  ? 'ক্যাটেগরি'
                  : categoryController.currentCategory.value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Debug button - show current mapping
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: Text('Category Mapping (${categoryNameToId.length})'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: categoryNameToId.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text('${entry.key} -> ${entry.value}'),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart screen
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Sort & Filter Buttons
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        showSortPanel(true);
                        showFilterPanel(false);
                      },
                      icon: const Icon(Icons.sort, color: Colors.black87),
                      label: const Text(
                        "Sort",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showFilterPanel(true);
                        showSortPanel(false);
                      },
                      icon: const Icon(Icons.filter_list, color: Colors.black87),
                      label: const Text(
                        "Filter",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Products Grid with Children Categories
              Expanded(
                child: Obx(() {
                  final currentCategory = categoryController.currentCategory.value;

                  // Show loading state
                  if (productController.isLoading.value) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'পণ্য লোড হচ্ছে...',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  // Show error state
                  if (productController.errorMessage.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'ত্রুটি: ${productController.errorMessage.value}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _loadProductsForCategory(currentCategory),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('আবার চেষ্টা করুন'),
                          ),
                        ],
                      ),
                    );
                  }

                  final products = productController.products;
                  final sortedProducts = applySort(products.toList());

                  // Show empty state
                  if (sortedProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_basket_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'এই ক্যাটেগরিতে কোনো পণ্য নেই',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'অনুগ্রহ করে অন্য ক্যাটেগরি চেষ্টা করুন',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              categoryController.updateCategory('মসলা', null);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('ডিফল্ট ক্যাটেগরিতে যান'),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // ✅ Children Categories Section - Category2Controller ব্যবহার করে
                      if (category2Controller.canShowChildren) ...[
                        Container(
                          height: 120,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'সাব-ক্যাটেগরি:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: category2Controller.activeChildren.length,
                                  itemBuilder: (context, index) {
                                    final child = category2Controller.activeChildren[index];
                                    return GestureDetector(
                                      onTap: () {
                                        // Sub-category select করলে products load করুন
                                        productController.loadProductsByCategory(child.id);
                                        categoryController.updateCategory(child.title, null);
                                        category2Controller.selectChildCategory(child);
                                      },
                                      child: Container(
                                        width: 90,
                                        margin: const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                            color: AppColors.primaryLight,
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Child category image
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primaryLight.withOpacity(0.3),
                                              ),
                                              child: child.hasImage
                                                  ? ClipOval(
                                                      child: Image.network(
                                                        child.imageUrl,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) => 
                                                            Icon(Icons.category, size: 24, color: AppColors.primary),
                                                        loadingBuilder: (context, child, loadingProgress) {
                                                          if (loadingProgress == null) return child;
                                                          return Center(
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              value: loadingProgress.expectedTotalBytes != null
                                                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                  : null,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : Icon(Icons.category, size: 24, color: AppColors.primary),
                                            ),
                                            const SizedBox(height: 6),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Text(
                                                child.title,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // ✅ Products Count Info
                      if (sortedProducts.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'মোট ${sortedProducts.length}টি পণ্য',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'সর্ট: ${selectedSort.value}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // ✅ Products Grid
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: sortedProducts.length,
                          itemBuilder: (context, index) {
                            final product = sortedProducts[index];
                            return _buildProductCard(product);
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),

          // ✅ Sort Panel
          Obx(() => showSortPanel.value ? _buildSortPanel(sortOptions) : const SizedBox.shrink()),

          // ✅ Filter Panel
          Obx(() => showFilterPanel.value ? _buildFilterPanel() : const SizedBox.shrink()),
        ],
      ),
    );
  }

  // ✅ Product Card Widget
  Widget _buildProductCard(ProductModel product) {
    return InkWell(
      onTap: () => _navigateToProductDetails(product),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Price Section
                  _buildPriceSection(product),
                  
                  const SizedBox(height: 4),
                  
                  // Unit Type
                  if (product.unitTypeText.isNotEmpty)
                    Text(
                      product.unitTypeText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  
                  const SizedBox(height: 8),
                  
                  // Add to Cart Button
                  _buildAddToCartButton(product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Price Section Widget
  Widget _buildPriceSection(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.hasDiscount) ...[
          Text(
            product.formattedPrice,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontSize: 12,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            product.formattedFinalPrice,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ] else
          Text(
            product.formattedPrice,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
      ],
    );
  }

  // ✅ Add to Cart Button
  Widget _buildAddToCartButton(ProductModel product) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: product.inStock ? AppColors.primary : Colors.grey,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: product.inStock ? () => _addToCart(product) : null,
        child: Text(
          product.inStock ? "কার্টে যোগ করুন" : "স্টক নেই",
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  // ✅ Add to Cart Logic
  void _addToCart(ProductModel product) {
    final authController = Get.find<AuthController>();
    final item = CartItem(
      id: product.id,
      name: product.title,
      category: categoryController.currentCategory.value,
      price: product.finalPrice,
      quantity: 1,
      imagePath: product.imageUrl,
    );

    if (authController.isLoggedIn.value) {
      cartController.addToCart(item);
      Get.snackbar(
        "সফল!",
        "${product.title} কার্টে যোগ করা হয়েছে",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      authController.pendingAction = () {
        cartController.addToCart(item);
        Get.snackbar(
          "সফল!",
          "${product.title} কার্টে যোগ করা হয়েছে",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      };
      Get.snackbar(
        "লগইন প্রয়োজন",
        "কার্টে যোগ করতে লগইন করুন",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // ✅ Navigate to Product Details
  void _navigateToProductDetails(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          product: {
            "id": product.id,
            "name": product.title,
            "price": product.finalPrice,
            "image": product.imageUrl,
            "description": product.description ?? '',
            "category": product.primaryCategory?.title ?? '',
            "discount": product.hasDiscount ? product.discountPrice : '0.00',
            "inStock": product.inStock,
            "quantity": product.quantity,
            "originalPrice": double.tryParse(product.price) ?? 0.0,
            "unit": product.unitTypeText,
          },
        ),
      ),
    );
  }

  // ✅ Sort Panel Widget
  Widget _buildSortPanel(List<String> sortOptions) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "সর্ট করুন",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => showSortPanel(false),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: sortOptions
                    .map(
                      (option) => Obx(() => RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: selectedSort.value,
                            onChanged: (value) {
                              selectedSort(value!);
                              showSortPanel(false);
                            },
                          )),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Filter Panel Widget
  Widget _buildFilterPanel() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "ফিল্টার",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => showFilterPanel(false),
                ),
              ],
            ),
             Expanded(child: FilterBottomSheet()),
          ],
        ),
      ),
    );
  }
}