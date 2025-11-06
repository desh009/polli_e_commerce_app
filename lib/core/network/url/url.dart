// lib/core/network/urls.dart
class Url {
  static const String baseUrl = "http://192.168.0.166:8000";

  // 🔐 Auth related
  static const String login = "$baseUrl/api/login";
  static const String register = "$baseUrl/api/register";
  static const String logout = "$baseUrl/api/logout";
  static const String userProfile = "$baseUrl/api/user-profile";
  static const String updateProfile = "$baseUrl/api/update-profile";
  static const String changePassword = "$baseUrl/api/change-password";

  // 🟢 Category related
  static const String categoryList = "$baseUrl/api/category";
  static String categoryById(int id) => "$baseUrl/api/category/$id";

  // 🟢 Slider related
  static const String slider = "$baseUrl/api/slider";

  // 🟢 Product related
  static const String productList = "$baseUrl/api/product";
  static String productById(int id) => "$baseUrl/api/product/$id";

  // ✅ Category-wise products endpoint
  static String productsByCategory(int categoryId) =>
      "$baseUrl/api/product?category_id=$categoryId";

  // 🟢 Brand related
  static const String brandList = "$baseUrl/api/brand";
  static String brandById(int id) => "$baseUrl/api/brand/$id";

  // 🟢 Order related
  static const String createOrder = "$baseUrl/api/order";
  static String orderById(int id) => "$baseUrl/api/order/$id";
  static const String orderHistory = "$baseUrl/api/orders";

  // ✅ Checkout endpoint
  static const String checkout = "$baseUrl/api/checkout";

  // 🛒 Cart related (যদি থাকে)
  static const String cart = "$baseUrl/api/cart";
  static String cartItem(int id) => "$baseUrl/api/cart/$id";

  // 🔍 Search related (যদি থাকে)
  static String searchProduct(String query) =>
      "$baseUrl/api/product?search=$query";
}