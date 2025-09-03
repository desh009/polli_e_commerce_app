import 'package:get/get.dart';

class WishlistController extends GetxController {
  // Dummy Wishlist items
  var wishlist = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  // Fake data load (API call এর জায়গায় আসল API দিবে)
  void fetchWishlist() {
    wishlist.value = [
      {
        "id": "P101",
        "name": "Green T-Shirt",
        "price": 750,
        "image": "assets/images/product1.png",
      },
      {
        "id": "P102",
        "name": "Casual Shoes",
        "price": 1200,
        "image": "assets/images/product2.png",
      },
    ];
  }

  // Remove from wishlist
  void removeFromWishlist(String id) {
    wishlist.removeWhere((item) => item["id"] == id);
  }
}
