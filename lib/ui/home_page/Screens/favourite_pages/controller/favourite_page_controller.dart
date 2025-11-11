// lib/core/controller/favourite_controller.dart - Fixed version
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController {
  final RxList<Map<String, dynamic>> favouriteProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    print('🎯 FavouriteController initialized with ${favouriteProducts.length} items');
  }

  // Check if product is favourite
  bool isFavourite(int productId) {
    final exists = favouriteProducts.any((product) => product['id'] == productId);
    print('🔍 Checking favourite for product $productId: $exists');
    return exists;
  }

  // Add to favourite with complete data
  void addToFavourite({
    required int id,
    required String title,
    required String price,
    required String image,
    required String category,
    String? description,
    bool hasDiscount = false,
    String? discountPrice,
  }) {
    if (!isFavourite(id)) {
      final productData = {
        'id': id,
        'title': title,
        'price': price,
        'image': image,
        'category': category,
        'description': description ?? 'No description available',
        'hasDiscount': hasDiscount,
        'discountPrice': discountPrice,
        'addedAt': DateTime.now().toString(),
        'isAvailable': true,
      };

      favouriteProducts.add(productData);
      
      print('✅ ADDED TO FAVOURITES: $title (ID: $id)');
      print('📊 Total favourites: ${favouriteProducts.length}');
      
      Get.snackbar(
        "Added to Favourites ❤️",
        "$title added to your favourites",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.pink,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } else {
      print('⚠️ Product $id is already in favourites');
    }
  }

  // Remove from favourite
  void removeFromFavourite(int productId) {
    final product = favouriteProducts.firstWhere(
      (product) => product['id'] == productId,
      orElse: () => {},
    );
    
    if (product.isNotEmpty) {
      favouriteProducts.removeWhere((product) => product['id'] == productId);
      
      print('❌ REMOVED FROM FAVOURITES: ${product['title']} (ID: $productId)');
      print('📊 Total favourites: ${favouriteProducts.length}');
      
      Get.snackbar(
        "Removed from Favourites 💔",
        "${product['title']} removed from favourites",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

  // Toggle favourite - FIXED VERSION
  void toggleFavourite({
    required int id,
    required String title,
    required String price,
    required String image,
    required String category,
    String? description,
    bool hasDiscount = false,
    String? discountPrice,
  }) {
    print('🔄 TOGGLE FAVOURITE: $title (ID: $id)');
    
    if (isFavourite(id)) {
      removeFromFavourite(id);
    } else {
      addToFavourite(
        id: id,
        title: title,
        price: price,
        image: image,
        category: category,
        description: description,
        hasDiscount: hasDiscount,
        discountPrice: discountPrice,
      );
    }
    
    // Debug: Print all favourites
    _printAllFavourites();
  }

  // Get favourite count
  int get favouriteCount => favouriteProducts.length;

  // Clear all favourites
  void clearFavourites() {
    favouriteProducts.clear();
    print('🗑️ All favourites cleared');
  }

  // Get all favourites for display
  List<Map<String, dynamic>> get allFavourites {
    print('📋 Getting all favourites: ${favouriteProducts.length} items');
    return favouriteProducts.toList();
  }

  // Debug method to print all favourites
  void _printAllFavourites() {
    print('======= ALL FAVOURITES (${favouriteProducts.length}) =======');
    for (var product in favouriteProducts) {
      print('❤️ ${product['title']} (ID: ${product['id']})');
    }
    print('============================================');
  }
}