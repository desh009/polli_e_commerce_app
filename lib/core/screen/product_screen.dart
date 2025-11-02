// lib/core/screen/product_details_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/cart_item/cart_item.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/view/add_to_cart_scree.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/view/chek_out_view.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Login_screen.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_2_response/response/product_2_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_2_response/response/product_2_response.dart';
import 'package:polli_e_commerce_app/core/widgets/auth_controller.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId, required Map<String, Object> product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductDetailController productController = Get.find();
  final AuthController authController = Get.find();
  final CartController cartController = Get.find();

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  void _loadProduct() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.loadProductDetail(widget.productId);
    });
  }

  void _addToCart() {
    final product = productController.currentProduct;
    if (product == null) return;

    final item = CartItem(
      id: product.id,
      name: product.title,
      category: productController.mainCategoryName,
      price: double.parse(product.price),
      quantity: 1,
      imagePath: product.fixedImageUrl, 
    );

    // ✅ সরাসরি Add to Cart - Login required নাই
    cartController.addToCart(item);
    
    Get.snackbar(
      "Success ✅",
      "${product.title} added to cart",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  void _buyNow() {
    final product = productController.currentProduct;
    if (product == null) return;

    // ✅ Buy Now এর জন্য Login required
    if (!authController.isLoggedIn.value) {
      final item = CartItem(
        id: product.id,
        name: product.title,
        category: productController.mainCategoryName,
        price: double.parse(product.price),
        quantity: 1,
        imagePath: product.fixedImageUrl, 
      );

      // ✅ Pending action set করুন for buy now flow
      authController.pendingAction = () {
        cartController.addToCart(item);
        // ✅ CheckoutScreen-এ navigate করুন
        Get.to(() => CheckoutScreen());
      };
      
      // ✅ Login screen এ navigate করুন
      Get.to(() => LoginScreen());
      
      Get.snackbar(
        "Login Required 🔐",
        "Please login to proceed with purchase",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // ✅ User logged in থাকলে CheckoutScreen-এ navigate করুন
    _navigateToCheckout(product);
  }

  void _navigateToCheckout(SingleProductModel product) {
    final item = CartItem(
      id: product.id,
      name: product.title,
      category: productController.mainCategoryName,
      price: double.parse(product.price),
      quantity: 1,
      imagePath: product.fixedImageUrl, 
    );

    // Add to cart first (যদি আগে না থাকে)
    bool itemAlreadyInCart = cartController.cartItems.any((cartItem) => cartItem.id == item.id);
    if (!itemAlreadyInCart) {
      cartController.addToCart(item);
    }

    // Then directly navigate to checkout screen
    Get.to(() => CheckoutScreen());
    
    Get.snackbar(
      "Proceed to Checkout 🛒",
      "${product.title} added to cart. Proceed to checkout.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          productController.currentProduct?.title ?? 'Product Details',
        )),
        backgroundColor: Colors.green,
        actions: [
          // ✅ Cart Icon with Badge
          Obx(() => Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Get.to(() => CartScreen(product: {}));
                },
              ),
              if (cartController.totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartController.totalItems}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          )),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => productController.refreshProduct(widget.productId),
          ),
        ],
      ),
      body: Obx(() {
        if (productController.isLoading.value && 
            !productController.hasProduct) {
          return Center(child: CircularProgressIndicator());
        }

        if (productController.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  productController.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadProduct,
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!productController.hasProduct) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Product not found'),
              ],
            ),
          );
        }

        final product = productController.currentProduct!;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: double.infinity,
                height: 300,
                child: Stack(
                  children: [
                    // Main Image
                    Image.network(
                      product.fixedImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                    // Discount Badge
                    if (product.hasDiscount)
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${product.discountPercent}% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Product Info
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Category
                    if (productController.mainCategoryName.isNotEmpty)
                      Text(
                        'Category: ${productController.mainCategoryName}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    
                    SizedBox(height: 16),
                    
                    // Price Section
                    Row(
                      children: [
                        Text(
                          productController.displayPrice,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (product.hasDiscount) ...[
                          SizedBox(width: 12),
                          Text(
                            '৳${product.price}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Stock Status
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: productController.isProductInStock 
                            ? Colors.green[50] 
                            : Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: productController.isProductInStock 
                              ? Colors.green 
                              : Colors.red,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            productController.isProductInStock 
                                ? Icons.check_circle 
                                : Icons.cancel,
                            color: productController.isProductInStock 
                                ? Colors.green 
                                : Colors.red,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              productController.isProductInStock 
                                  ? 'In Stock (${product.quantity} available)' 
                                  : 'Out of Stock',
                              style: TextStyle(
                                color: productController.isProductInStock 
                                    ? Colors.green 
                                    : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Description
                    const Text(
                      "Description:",
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      product.description ?? 'No description available for this product.',
                      style: const TextStyle(fontSize: 16),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Product Details
                    const Text(
                      "Product Details:",
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildDetailItem('SKU', product.sku),
                    _buildDetailItem('Brand ID', '${product.brandId}'),
                    _buildDetailItem('Unit Type', '${product.unitType}'),
                    _buildDetailItem('Total Sold', '${product.totalSell}'),
                    _buildDetailItem('Stockable', product.stockable == 1 ? 'Yes' : 'No'),
                    
                    SizedBox(height: 30),
                    
                    // Add to Cart and Buy Now Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Add to Cart Button - NO LOGIN REQUIRED
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: productController.isProductInStock 
                                    ? Colors.green 
                                    : Colors.grey,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: productController.isProductInStock 
                                  ? _addToCart 
                                  : null,
                              child: const Text(
                                "Add to Cart",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        
                        // Buy Now Button - LOGIN REQUIRED
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: productController.isProductInStock 
                                    ? Colors.orange 
                                    : Colors.grey,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: productController.isProductInStock 
                                  ? _buyNow 
                                  : null,
                              child: const Text(
                                "Buy Now",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ✅ User login status display
                    SizedBox(height: 10),
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          authController.isLoggedIn.value 
                              ? Icons.verified_user 
                              : Icons.person_outline,
                          color: authController.isLoggedIn.value 
                              ? Colors.green 
                              : Colors.orange,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          authController.isLoggedIn.value 
                              ? "Logged In" 
                              : "Guest User - Login for Buy Now",
                          style: TextStyle(
                            color: authController.isLoggedIn.value 
                                ? Colors.green 
                                : Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )),

                    // ✅ View Cart Button
                    SizedBox(height: 10),
                    if (cartController.totalItems > 0)
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Get.to(() => CartScreen(product: {}));
                          },
                          child: Text(
                            "View Cart (${cartController.totalItems} items)",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}