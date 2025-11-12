// lib/core/network/urls.dart
class Url {
  // ✅ Development & Production URLs
  static const String developmentBaseUrl = "http://192.168.0.165:8000";
  static const String productionBaseUrl = "https://inventory.growtech.com.bd";
  
  // ✅ Current base URL (easily switch between dev and prod)
  static const String baseUrl = developmentBaseUrl; // Change to productionBaseUrl for live
  
  // ✅ Or use environment based URL
  static String get base1Url {
    const bool isDevelopment = bool.fromEnvironment('DEBUG', defaultValue: true);
    return isDevelopment ? developmentBaseUrl : productionBaseUrl;
  }

  // 🔐 Auth related
  static const String login = "$baseUrl/api/login";
  static const String register = "$baseUrl/api/register";
  static const String logout = "$baseUrl/api/logout";
  static const String userProfile = "$baseUrl/api/user-profile";
  static const String updateProfile = "$baseUrl/api/update-profile";
  static const String changePassword = "$baseUrl/api/change-password";
  static const String forgotPassword = "$baseUrl/api/forgot-password";
   // ✅ ADD THIS  static const String verifyOtp = "$baseUrl/api/register/verify";
  static const String verifyOtp = "$baseUrl/api/register/verify";

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

  // ✅ NEW: Email verification endpoints
  static const String emailVerification = "$baseUrl/api/email/verify";
  static const String resendVerification = "$baseUrl/api/email/verification-notification";
  static String checkApprovalStatus(String email) => "$baseUrl/api/check-approval?email=$email";
}





// class Url {
//   static const String baseUrl = "https://inventory.growtech.com.bd";

//   // 🔐 Auth related
//   static const String login = "$baseUrl/api/login";
//   static const String register = "$baseUrl/api/register";
//   static const String logout = "$baseUrl/api/logout";
//   static const String userProfile = "$baseUrl/api/user-profile";
//   static const String updateProfile = "$baseUrl/api/update-profile";
//   static const String changePassword = "$baseUrl/api/change-password";

//   // 🟢 Category related
//   static const String categoryList = "$baseUrl/api/category";
//   static String categoryById(int id) => "$baseUrl/api/category/$id";

//   // 🟢 Slider related
//   static const String slider = "$baseUrl/api/slider";
//   // static String searchProduct(String query) =>
//   //     "$baseUrl/api/product?search=$query";//       "$baseUrl/api/product?search=$query";

//   // 🟢 Product related
//   static const String productList = "$baseUrl/api/product";
//   static String productById(int id) => "$baseUrl/api/product/$id";

//   // ✅ Category-wise products endpoint
//   static String productsByCategory(int categoryId) =>
//       "$baseUrl/api/product?category_id=$categoryId";

//   // 🟢 Brand related
//   static const String brandList = "$baseUrl/api/brand";
//   static String brandById(int id) => "$baseUrl/api/brand/$id";

//   // 🟢 Order related
//   static const String createOrder = "$baseUrl/api/order";
//   static String orderById(int id) => "$baseUrl/api/order/$id";
//   static const String orderHistory = "$baseUrl/api/orders";

//   // ✅ Checkout endpoint
//   static const String checkout = "$baseUrl/api/checkout";

//   static const String emailVerification = "$baseUrl/api/email/verify";
//   static const String resendVerification = "$baseUrl/api/email/verification-notification";
//   static String checkApprovalStatus(String email) => "$baseUrl/api/check-approval?email=$email";
//   // 🛒 Cart related (যদি থাকে)
//   static const String cart = "$baseUrl/api/cart";
//   static String cartItem(int id) => "$baseUrl/api/cart/$id";

//   // 🔍 Search related (যদি থাকে)
//   static String searchProduct(String query) =>
//       "$baseUrl/api/product?search=$query";


// }