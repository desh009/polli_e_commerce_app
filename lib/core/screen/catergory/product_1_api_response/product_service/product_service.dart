// import 'package:polli_e_commerce_app/core/network/api_client.dart';
// import 'package:polli_e_commerce_app/core/network/api_response.dart';
// import 'package:polli_e_commerce_app/core/network/url/url.dart';
// import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/product_1_response.dart';

// class ProductService {
//   final NetworkClient _networkClient;

//   ProductService({required NetworkClient networkClient})
//       : _networkClient = networkClient;

//   // সব প্রোডাক্ট লিস্ট পাওয়ার জন্য
//   Future<NetworkResponse> getAllProducts() async {
//     return await _networkClient.getRequest(Url.productList);
//   }

//   // ক্যাটাগরি অনুযায়ী প্রোডাক্ট পাওয়ার জন্য
//   Future<NetworkResponse> getProductsByCategory(int categoryId) async {
//     return await _networkClient.getRequest(
//       Url.productsByCategory(categoryId),
//     );
//   }

//   // নির্দিষ্ট প্রোডাক্ট ডিটেইলস পাওয়ার জন্য
//   Future<NetworkResponse> getProductById(int productId) async {
//     return await _networkClient.getRequest(
//       Url.productById(productId),
//     );
//   }

//   // JSON রেসপন্সকে মডেলে কনভার্ট করার মেথড
//   ProductApiResponse parseProductResponse(Map<String, dynamic> responseData) {
//     return ProductApiResponse.fromJson(responseData);
//   }

//   // ✅ যদি productByCategory getter দরকার হয় তবে এটি যোগ করুন
//   // এটি একটি computed property হিসেবে কাজ করবে
//   String get productByCategory => 'products_by_category';
// }