import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/controller/categpory_contrpoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/controller/product_1_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/product_1_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/repository/product_1_repository.dart';
import 'package:polli_e_commerce_app/core/screen/product_screen.dart';
import 'package:polli_e_commerce_app/core/widgets/auth_controller.dart';
import 'package:polli_e_commerce_app/core/screen/filter_bottom_sheet_screen.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

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
  late final CategoryController categoryController;
  late final CartController cartController;
  late final ProductController productController;

  bool showSortPanel = false;
  bool showFilterPanel = false;
  String selectedSort = "Price Low to High";

  // ✅ ক্যাটেগরি নাম → আইডি ম্যাপিং (API response অনুযায়ী আপডেট)
  // ✅ ক্যাটেগরি নাম → আইডি ম্যাপিং (API response অনুযায়ী)
  // ✅ Parent Categories (API অনুযায়ী)
  final Map<String, int> categoryNameToId = {
    'মসলা': 1,
    'তেল': 2,
    'গুড়': 3,
    'স্পেশাল আইটেম': 4,
  };

  // ✅ Sub-Categories (API অনুযায়ী)
  final Map<String, int> subCategoryNameToId = {
    'হলুদ': 6, // parent_id = 1 (মসলা)
    'মরিচ': 5, // parent_id = 1 (মসলা)
    'সরিষার তেল': 11, // parent_id = 2 (তেল)
    'নারিকেল তেল': 12, // যদি থাকে
    'মধু': 4, // parent_id = 4 (স্পেশাল আইটেম)
  };

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    print('🔄 CategoryScreen initialized');
    print(
      '📦 CategoryController registered: ${Get.isRegistered<CategoryController>()}',
    );
    print(
      '📦 ProductController registered: ${Get.isRegistered<ProductController>()}',
    );
    print(
      '📦 CartController registered: ${Get.isRegistered<CartController>()}',
    );

    // Observe category changes
    ever(categoryController.currentCategory, (String category) {
      if (category.isNotEmpty) {
        _loadProductsForCategory(category);
      }
    });

    // Initial category load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialCategory = widget.initialSelectedCategory ?? 'মসলা';

      // Parent বা Sub-category অনুযায়ী ID
      int? categoryId;
      if (categoryNameToId.containsKey(initialCategory)) {
        categoryId = categoryNameToId[initialCategory];
      } else if (subCategoryNameToId.containsKey(initialCategory)) {
        categoryId = subCategoryNameToId[initialCategory];
      }

      if (categoryId != null) {
        categoryController.updateCategory(
          initialCategory,
          widget.initialSelectedOption,
        );
        productController.loadProductsByCategory(categoryId);
      } else {
        print('❌ Category ID not found for: $initialCategory');
      }
    });
  }

  // ✅ Safe Controller Initialization
  void _initializeControllers() {
    // Category Controller
    if (Get.isRegistered<CategoryController>()) {
      categoryController = Get.find<CategoryController>();
    } else {
      categoryController = Get.put(CategoryController(), permanent: true);
    }

    // Cart Controller
    if (Get.isRegistered<CartController>()) {
      cartController = Get.find<CartController>();
    } else {
      cartController = Get.put(CartController(), permanent: true);
    }

    // Product Controller
    // Product Controller initialization part fix ↓

    if (Get.isRegistered<ProductController>()) {
      productController = Get.find<ProductController>();
    } else {
      final repository = ProductRepository(Get.find<NetworkClient>());
      productController = Get.put(
        ProductController(repository),
        permanent: true,
      );
    }
  }

  // ✅ Load Products for Category
  void _loadProductsForCategory(String category) {
    final categoryId = categoryNameToId[category];
    if (categoryId != null) {
      print('🔄 Loading products for category: "$category" (ID: $categoryId)');
      productController.loadProductsByCategory(categoryId);
    } else {
      print('❌ Category ID not found for: "$category"');
      Get.snackbar(
        'ত্রুটি',
        '$category ক্যাটেগরির জন্য আইডি পাওয়া যায়নি',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  // ✅ Sorting Logic
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
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // ✅ Sort & Filter Buttons
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
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
                      onPressed: () => setState(() {
                        showSortPanel = true;
                        showFilterPanel = false;
                      }),
                      icon: const Icon(Icons.sort, color: Colors.black87),
                      label: const Text(
                        "Sort",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() {
                        showFilterPanel = true;
                        showSortPanel = false;
                      }),
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.black87,
                      ),
                      label: const Text(
                        "Filter",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Product Grid
              Expanded(
                child: Obx(() {
                  final currentCategory =
                      categoryController.currentCategory.value;

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
                            onPressed: () =>
                                _loadProductsForCategory(currentCategory),
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
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                  );
                }),
              ),
            ],
          ),

          // ✅ Sort Panel
          if (showSortPanel) _buildSortPanel(sortOptions),

          // ✅ Filter Panel
          if (showFilterPanel) _buildFilterPanel(),
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
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => showSortPanel = false),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: sortOptions
                    .map(
                      (option) => RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: selectedSort,
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value!;
                            showSortPanel = false;
                          });
                        },
                      ),
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
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
