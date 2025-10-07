class Url {
  static const String baseUrl = "https://inventory.growtech.com.bd";
  // static const String categoryList = "$baseUrl/api/categories";
  // Or if your API uses:
  static const String categoryList = "$baseUrl/api/category";
    static String categoryById(int id) => "$baseUrl/api/category/$id";

}