// import 'package:get/get.dart';
// import 'package:polli_e_commerce_app/core/network/api_client.dart';
// import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/controller/product_1_controller.dart';
// import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/repository/product_1_repository.dart';


// class AppBinding extends Bindings {
//   @override
//   void dependencies() {
//     // Network Client (আপনার existing NetworkClient ব্যবহার করুন)
//     Get.lazyPut<NetworkClient>(() => NetworkClient(
//       onUnAuthorize: () {
//         // Handle unauthorized access
//         Get.offAllNamed('/login');
//       },
//       commonHeaders: () {
//         return {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           // Add any other common headers here
//         };
//       },
//     ), fenix: true);
    
//     // Repository
//     Get.lazyPut<ProductRepository>(
//       () => ProductRepository(Get.find<NetworkClient>()),
//       fenix: true,
//     );
    
//     // Controller
//     Get.lazyPut<ProductController>(
//       () => ProductController(repository: Get.find<ProductRepository>()),
//       fenix: true,
//     );
//   }
// }