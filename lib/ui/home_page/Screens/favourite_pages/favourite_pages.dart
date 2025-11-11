// lib/ui/home_page/favourite_pages/favourite_pages.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/product_screen.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/Screens/favourite_pages/controller/favourite_page_controller.dart' show FavouriteController;

class FavouritePage extends StatelessWidget {
  FavouritePage({super.key});
  
  final FavouriteController favouriteController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favourites (${favouriteController.favouriteCount})"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Obx(() => 
            favouriteController.favouriteCount > 0
              ? IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () => _showClearAllDialog(),
                  tooltip: 'Clear All Favourites',
                )
              : SizedBox(),
          ),
        ],
      ),
      body: Obx(() {
        final favourites = favouriteController.allFavourites;
        
        if (favourites.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: favourites.length,
          itemBuilder: (context, index) {
            final product = favourites[index];
            return _buildFavouriteItem(product, index, context);
          },
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            "No Favourites Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Add products to your favourites list",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavouriteItem(Map<String, dynamic> product, int index, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          _navigateToProductScreen(product, context);
        },
        child: ListTile(
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: product['image'] != null && product['image'].toString().isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product['image'].toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image_not_supported, color: Colors.grey);
                      },
                    ),
                  )
                : Icon(Icons.shopping_bag, color: AppColors.primary),
          ),
          title: Text(
            product['title']?.toString() ?? 'Unknown Product',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                '৳${product['price']}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.favorite, color: Colors.pink),
            onPressed: () {
              _removeFavourite(product['id']);
            },
          ),
        ),
      ),
    );
  }

  void _removeFavourite(int productId) {
    favouriteController.removeFromFavourite(productId);
  }

  void _showClearAllDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Clear All Favourites?"),
        content: Text("Are you sure you want to remove all products from your favourites?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              favouriteController.clearFavourites();
            },
            child: Text("Clear All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Product Screen-এ navigate করার মেথড
  void _navigateToProductScreen(Map<String, dynamic> product, BuildContext context) {
    try {
      // Option 1: সরাসরি MaterialPageRoute ব্যবহার করুন
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(
            productId: product['id'],
            productData: product, product: {}, productName: '',
          ),
        ),
      );
      
      // Option 2: যদি আপনার ProductDetailsScreen না থাকে, তাহলে এইভাবে试试看
      // Navigator.pushNamed(
      //   context,
      //   '/product-details',
      //   arguments: {
      //     'productId': product['id'],
      //     'product': product,
      //   },
      // );
      
    } catch (e) {
      print('Navigation error: $e');
      // Fallback: Simple dialog showing product info
      _showProductPreview(product, context);
    }
  }

  // Fallback method যদি navigation fail হয়
  void _showProductPreview(Map<String, dynamic> product, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product['title']?.toString() ?? 'Product Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product['image'] != null && product['image'].toString().isNotEmpty)
              Image.network(
                product['image'].toString(),
                height: 150,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16),
            Text('Price: ৳${product['price']}'),
            SizedBox(height: 8),
            Text('Description: ${product['description'] ?? 'No description available'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}