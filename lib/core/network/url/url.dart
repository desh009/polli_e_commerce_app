class Url {
  static const String baseUrl = "https://inventory.growtech.com.bd";

  // 🟢 Category related
  static const String categoryList = "$baseUrl/api/category";
  static String categoryById(int id) => "$baseUrl/api/category/$id";

  // 🟢 Slider related
  static const String slider = "$baseUrl/api/slider";

  // 🟢 Product related
  static const String productList = "$baseUrl/api/product";
  static String productById(int id) => "$baseUrl/api/product/$id";

  // ✅ Corrected Category-wise products endpoint
  static String productsByCategory(int categoryId) =>
      "$baseUrl/api/product?category_id=$categoryId";

  // 🟢 Brand related (if needed)
  static const String brandList = "$baseUrl/api/brand";
  static String brandById(int id) => "$baseUrl/api/brand/$id";

  // 🟢 Order related (if needed)
  static const String createOrder = "$baseUrl/api/order";
  static String orderById(int id) => "$baseUrl/api/order/$id";
  static const String orderHistory = "$baseUrl/api/orders";
}
