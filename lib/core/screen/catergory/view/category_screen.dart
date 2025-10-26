import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/controller/category_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/response/category_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/controller/product_1_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/product_api_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/repository/product_1_repository.dart';
import 'package:polli_e_commerce_app/core/screen/product_screen.dart';
import 'package:polli_e_commerce_app/core/widgets/auth_controller.dart';
import 'package:polli_e_commerce_app/core/screen/filter_bottom_sheet_screen.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/2nd_category_model/2nd_category_model.dart';

// Category2 Controller import
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/controller/2nd_category_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/repository/2nd_category_repository.dart';

// Category1 Repository import
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/repository/category_repository.dart';

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
  late final Category2Controller category2Controller;

  // UI State
  bool showSortPanel = false;
  bool showFilterPanel = false;
  String selectedSort = "Price Low to High";

  // Category Mapping
  final Map<String, int> categoryNameToId = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupCategoryMapping();

    // Initial category load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialCategory = widget.initialSelectedCategory ?? '';
      if (initialCategory.isNotEmpty) {
        _handleInitialCategory(initialCategory);
      } else {
        categoryController.updateCategory('মসলা', null);
      }
    });
  }

  void _initializeControllers() {
    // Category1 Controller
    if (Get.isRegistered<Category1Controller>()) {
      categoryController = Get.find<Category1Controller>();
    } else {
      final categoryRepository = Category1Repository(Get.find<NetworkClient>());
      categoryController = Get.put(
        Category1Controller(categoryRepository),
        permanent: true,
      );
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

    // Category2 Controller
    if (Get.isRegistered<Category2Controller>()) {
      category2Controller = Get.find<Category2Controller>();
    } else {
      final repository = Category2Repository(Get.find<NetworkClient>());
      category2Controller = Get.put(
        Category2Controller(repository),
        permanent: true,
      );
    }
  }

  void _setupCategoryMapping() {
    // Observe category changes
    ever(categoryController.currentCategory, (String category) {
      if (category.isNotEmpty) {
        _loadProductsForCategory(category);
        _loadCategoryDetails(category);
      }
    });

    // Initial sync
    _updateCategoryMappingFromCategory1(categoryController.categories);
  }

  void _updateCategoryMappingFromCategory1(List<Category> categories) {
    categoryNameToId.clear();
    for (var category in categories) {
      categoryNameToId[category.title] = category.id;
    }
  }

  int? _getCategoryIdByName(String categoryName) {
    // Check in mapping first
    if (categoryNameToId.containsKey(categoryName)) {
      return categoryNameToId[categoryName];
    }

    // Fallback to controllers
    final idFromController = categoryController.getCategoryIdByName(categoryName);
    if (idFromController != null) return idFromController;

    final idFromCategory2 = category2Controller.getCategoryIdByName(categoryName);
    if (idFromCategory2 != null) return idFromCategory2;

    return null;
  }

  void _handleInitialCategory(String categoryName) {
    final categoryId = _getCategoryIdByName(categoryName);
    if (categoryId != null) {
      categoryController.updateCategory(categoryName, widget.initialSelectedOption);
      productController.loadProductsByCategory(categoryId);
      _loadCategoryDetails(categoryName);
    } else {
      Get.snackbar(
        'ত্রুটি',
        '$categoryName ক্যাটেগরির জন্য আইডি পাওয়া যায়নি',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      categoryController.updateCategory('মসলা', null);
    }
  }

  void _loadProductsForCategory(String category) {
    final categoryId = _getCategoryIdByName(category);
    if (categoryId != null) {
      productController.loadProductsByCategory(categoryId);
    } else {
      Get.snackbar(
        'ত্রুটি',
        '$category ক্যাটেগরির জন্য আইডি পাওয়া যায়নি',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _loadCategoryDetails(String category) {
    final categoryId = _getCategoryIdByName(category);
    if (categoryId != null) {
      category2Controller.loadCategoryDetails(categoryId);
    }
  }

  List<ProductModel> applySort(List<ProductModel> products) {
    List<ProductModel> sortedList = List.from(products);
    switch (selectedSort) {
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
        title: Obx(
          () => Text(
            categoryController.currentCategory.value.isEmpty
                ? 'ক্যাটেগরি'
                : categoryController.currentCategory.value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
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
                        setState(() {
                          showSortPanel = true;
                          showFilterPanel = false;
                        });
                      },
                      icon: const Icon(Icons.sort, color: Colors.black87),
                      label: const Text("Sort"),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          showFilterPanel = true;
                          showSortPanel = false;
                        });
                      },
                      icon: const Icon(Icons.filter_list, color: Colors.black87),
                      label: const Text("Filter"),
                    ),
                  ],
                ),
              ),

              // Products Grid with Children Categories
              Expanded(
                child: Obx(() {
                  final currentCategory = categoryController.currentCategory.value;

                  // Loading State
                  if (productController.isLoading.value) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('পণ্য লোড হচ্ছে...'),
                        ],
                      ),
                    );
                  }

                  // Error State
                  if (productController.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 60, color: Colors.red[400]),
                          const SizedBox(height: 16),
                          Text('ত্রুটি: ${productController.errorMessage.value}'),
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
                  final sortedProducts = applySort(products);

                  // Empty State
                  if (sortedProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text('এই ক্যাটেগরিতে কোনো পণ্য নেই'),
                          const SizedBox(height: 8),
                          Text('অনুগ্রহ করে অন্য ক্যাটেগরি চেষ্টা করুন'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => categoryController.updateCategory('মসলা', null),
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
                      // Children Categories Section
                      if (category2Controller.canShowChildren) ...[
                        Container(
                          height: 140,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
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
                                        productController.loadProductsByCategory(child.id);
                                        categoryController.updateCategory(child.title, null);
                                        category2Controller.selectChildCategory(child);
                                      },
                                      child: Container(
                                        width: 100,
                                        margin: const EdgeInsets.only(right: 12),
                                        padding: const EdgeInsets.all(8),
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
                                          border: Border.all(color: AppColors.primaryLight, width: 1),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Child category image
                                            Container(
                                              constraints: const BoxConstraints(maxWidth: 45, maxHeight: 45),
                                              child: child.hasImage
                                                  ? ClipOval(
                                                      child: Image.network(
                                                        child.imageUrl,
                                                        fit: BoxFit.cover,
                                                        width: 45,
                                                        height: 45,
                                                        errorBuilder: (context, error, stackTrace) => Icon(
                                                          Icons.category,
                                                          size: 20,
                                                          color: AppColors.primary,
                                                        ),
                                                      ),
                                                    )
                                                  : Icon(Icons.category, size: 20, color: AppColors.primary),
                                            ),
                                            const SizedBox(height: 6),
                                            Flexible(
                                              child: Text(
                                                child.title,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
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

                      // Products Count
                      if (sortedProducts.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('মোট ${sortedProducts.length}টি পণ্য'),
                              Text('সর্ট: $selectedSort'),
                            ],
                          ),
                        ),
                      ],

                      // Products Grid
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

          // Sort Panel
          if (showSortPanel) _buildSortPanel(sortOptions),

          // Filter Panel
          if (showFilterPanel) _buildFilterPanel(),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return InkWell(
      onTap: () => _navigateToProductDetails(product),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    product.image, // ✅ নতুন model property
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    ),
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
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Price Section
                  _buildPriceSection(product),

                  const SizedBox(height: 4),

                  // Unit Type
                  Text(
                    product.unitText, // ✅ নতুন model property
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _buildPriceSection(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.hasDiscount) ...[ // ✅ নতুন model property
          Text(
            '৳${product.price.toStringAsFixed(2)}', // ✅ নতুন model property
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            '৳${product.finalPrice.toStringAsFixed(2)}', // ✅ নতুন model property
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ] else
          Text(
            '৳${product.price.toStringAsFixed(2)}', // ✅ নতুন model property
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
      ],
    );
  }

  Widget _buildAddToCartButton(ProductModel product) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: product.isInStock ? AppColors.primary : Colors.grey, // ✅ নতুন model property
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: product.isInStock ? () => _addToCart(product) : null, // ✅ নতুন model property
        child: Text(
          product.isInStock ? "কার্টে যোগ করুন" : "স্টক নেই", // ✅ নতুন model property
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  void _addToCart(ProductModel product) {
    final authController = Get.find<AuthController>();
    final item = CartItem(
      id: product.id,
      name: product.title,
      category: categoryController.currentCategory.value,
      price: product.finalPrice, // ✅ নতুন model property
      quantity: 1,
      imagePath: product.image, // ✅ নতুন model property
    );

    if (authController.isLoggedIn.value) {
      cartController.addToCart(item);
      Get.snackbar(
        "সফল!",
        "${product.title} কার্টে যোগ করা হয়েছে",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      authController.pendingAction = () => cartController.addToCart(item);
      Get.snackbar(
        "লগইন প্রয়োজন",
        "কার্টে যোগ করতে লগইন করুন",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _navigateToProductDetails(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          product: {
            "id": product.id,
            "name": product.title,
            "price": product.finalPrice, // ✅ নতুন model property
            "image": product.image, // ✅ নতুন model property
            "description": product.description ?? '',
            "category": product.categoryName, // ✅ নতুন model property
            "discount": product.hasDiscount ? product.discountPrice : 0.0, // ✅ নতুন model property
            "inStock": product.isInStock, // ✅ নতুন model property
            "quantity": product.quantity,
            "originalPrice": product.price, // ✅ নতুন model property
            "unit": product.unitText, // ✅ নতুন model property
          }, productId: product.id,
        ),
      ),
    );
  }

  Widget _buildSortPanel(List<String> sortOptions) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("সর্ট করুন", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => showSortPanel = false),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: sortOptions.map((option) => RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: selectedSort,
                  onChanged: (value) {
                    setState(() {
                      selectedSort = value!;
                      showSortPanel = false;
                    });
                  },
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("ফিল্টার", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => showFilterPanel = false),
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