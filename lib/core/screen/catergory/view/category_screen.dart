import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/controller/category_controller.dart';
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
  late final Category1Controller categoryController;
  late final CartController cartController;
  late final ProductController productController;

  // Reactive panels
  var showSortPanel = false.obs;
  var showFilterPanel = false.obs;
  var selectedSort = "Price Low to High".obs;

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    // Observe category changes
    ever(categoryController.currentCategory, (String category) {
      if (category.isNotEmpty) _loadProductsForCategory(category);
    });

    // Initial category load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialCategory = widget.initialSelectedCategory ?? '';
      if (initialCategory.isNotEmpty) {
        final categoryId = categoryController.getCategoryIdByName(initialCategory);
        if (categoryId != null) {
          categoryController.updateCategory(initialCategory, widget.initialSelectedOption);
          productController.loadProductsByCategory(categoryId);
        }
      }
    });
  }

  void _initializeControllers() {
    categoryController = Get.isRegistered<Category1Controller>()
        ? Get.find<Category1Controller>()
        : Get.put(Category1Controller(Get.find()), permanent: true);

    cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController(), permanent: true);

    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(
            ProductController(ProductRepository(Get.find<NetworkClient>())),
            permanent: true,
          );
  }

  void _loadProductsForCategory(String category) {
    final categoryId = categoryController.getCategoryIdByName(category);
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
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))],
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
                      label: const Text("Sort", style: TextStyle(color: Colors.black87)),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showFilterPanel(true);
                        showSortPanel(false);
                      },
                      icon: const Icon(Icons.filter_list, color: Colors.black87),
                      label: const Text("Filter", style: TextStyle(color: Colors.black87)),
                    ),
                  ],
                ),
              ),

              // Product Grid
              Expanded(
                child: Obx(() {
                  if (productController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (productController.errorMessage.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 60, color: Colors.red[400]),
                          const SizedBox(height: 16),
                          Text(productController.errorMessage.value, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _loadProductsForCategory(categoryController.currentCategory.value),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                            child: const Text('আবার চেষ্টা করুন'),
                          ),
                        ],
                      ),
                    );
                  }

                  final products = applySort(productController.products.toList());
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('এই ক্যাটেগরিতে কোনো পণ্য নেই'),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.75),
                    itemCount: products.length,
                    itemBuilder: (context, index) => _buildProductCard(products[index]),
                  );
                }),
              ),
            ],
          ),

          // Sort Panel
          Obx(() => showSortPanel.value ? _buildSortPanel(sortOptions) : const SizedBox.shrink()),

          // Filter Panel
          Obx(() => showFilterPanel.value ? _buildFilterPanel() : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final imageUrl = product.imageUrl?.isNotEmpty == true
        ? product.imageUrl
        : 'https://via.placeholder.com/150';

    return InkWell(
      onTap: () => _navigateToProductDetails(product),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  ),
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  _buildPriceSection(product),
                  const SizedBox(height: 8),
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
    return product.hasDiscount
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.formattedPrice,
                  style: const TextStyle(color: Colors.grey, fontSize: 12, decoration: TextDecoration.lineThrough)),
              Text(product.formattedFinalPrice, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          )
        : Text(product.formattedPrice, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16));
  }

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
        child: Text(product.inStock ? "কার্টে যোগ করুন" : "স্টক নেই", style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  void _addToCart(ProductModel product) {
    final authController = Get.find<AuthController>();
    final item = CartItem(
      id: product.id,
      name: product.title,
      category: categoryController.currentCategory.value,
      price: product.finalPrice,
      quantity: 1,
      imagePath: product.imageUrl ?? '',
    );

    if (authController.isLoggedIn.value) {
      cartController.addToCart(item);
      Get.snackbar("সফল!", "${product.title} কার্টে যোগ করা হয়েছে", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white, duration: const Duration(seconds: 2));
    } else {
      authController.pendingAction = () => cartController.addToCart(item);
      Get.snackbar("লগইন প্রয়োজন", "কার্টে যোগ করতে লগইন করুন", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white, duration: const Duration(seconds: 3));
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
            "price": product.finalPrice,
            "image": product.imageUrl ?? '',
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

  Widget _buildSortPanel(List<String> sortOptions) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10)]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(padding: EdgeInsets.all(16.0), child: Text("সর্ট করুন", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                IconButton(icon: const Icon(Icons.close), onPressed: () => showSortPanel(false)),
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

  Widget _buildFilterPanel() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10)]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(padding: EdgeInsets.all(16.0), child: Text("ফিল্টার", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                IconButton(icon: const Icon(Icons.close), onPressed: () => showFilterPanel(false)),
              ],
            ),
             Expanded(child: FilterBottomSheet()),
          ],
        ),
      ),
    );
  }
}
