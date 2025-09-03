import 'package:get/get.dart';

class HomeController extends GetxController {
  // 🔹 Example observable variables
  var cartCount = 0.obs;
  var wishlistCount = 0.obs;
  var selectedCategory = "".obs;

  // 🔹 Function to add item in cart
  void addToCart() {
    cartCount.value++;
  }

  // 🔹 Function to add item in wishlist
  void addToWishlist() {
    wishlistCount.value++;
  }

  // 🔹 Select category
  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
