// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/controller/chek_out_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/repository/chek_out_repository.dart';
import 'package:webview_flutter/webview_flutter.dart'; // WebView import করুন
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/controller/category_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/repository/category_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/controller/categpory_contrpoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/controller/product_1_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/repository/product_1_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_2_response/response/product_2_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_2_response/response/repository/product_2_repository.dart';
import 'package:polli_e_commerce_app/core/widgets/auth_controller.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/Slider_api/controller/slider_api_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/Slider_api/repository/slider_api_repository.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/controller/2nd_category_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/repository/2nd_category_repository.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/controller/drwaer_controller.dart';
import 'package:polli_e_commerce_app/ui/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // WebView Platform Initialization (AamarPay-এর জন্য জরুরি)
  // await _initializeWebView();

  /// 🔹 1. FIRST - NetworkClient Register করুন (সবচেয়ে আগে)
  final apiClient = NetworkClient(
    onUnAuthorize: () {
      print("🔐 Unauthorized! Redirect to login...");
    },
    commonHeaders: () => {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
  );
  Get.put<NetworkClient>(apiClient, permanent: true);
  print('✅ NetworkClient registered');

  /// 🔹 Order Repository
  Get.lazyPut<CheckoutRepository>(() => CheckoutRepository(networkClient: apiClient), fenix: true);
  print('✅ OrderRepository registered');

  /// 🔹 2. Auth Controller
  Get.put(AuthController(), permanent: true);
  print('✅ AuthController registered');

  /// 🔹 3. Cart Controller
  Get.put(CartController(), permanent: true);
  print('✅ CartController registered');

  /// 🔹 4. Repositories (সব repositories একসাথে)
  Get.put<Category1Repository>(Category1Repository(apiClient), permanent: true);
  print('✅ Category1Repository registered');

  Get.put<SliderRepository>(SliderRepository(networkClient: apiClient), permanent: true);
  print('✅ SliderRepository registered');

  // ✅ Product Repository
  Get.put<BaseProductRepository>(ProductRepository(apiClient), permanent: true);
  print('✅ BaseProductRepository registered');

  // ✅ Checkout Controller
  Get.put(CheckoutController(repository: 
    Get.find<CheckoutRepository>()
  ), permanent: true);
  print('✅ CheckoutController registered');

  // ✅ Product Detail Repository
  Get.put<BaseProductDetailRepository>(ProductDetailRepository(networkClient: apiClient), permanent: true);
  print('✅ BaseProductDetailRepository registered');

  /// 🔹 5. Controllers (সব controllers একসাথে)
  Get.put<Category1Controller>(Category1Controller(Get.find<Category1Repository>()), permanent: true);
  print('✅ Category1Controller registered');

  Get.put<CategoryController>(CategoryController(), permanent: true);
  print('✅ CategoryController registered');

  Get.put<SliderController>(SliderController(repository: Get.find<SliderRepository>()), permanent: true);
  print('✅ SliderController registered');

  Get.put<DrawerControllerX>(DrawerControllerX(), permanent: true);
  print('✅ DrawerControllerX registered');

  // ✅ Product Controller
  Get.put<ProductController>(ProductController(repository: Get.find<BaseProductRepository>()), permanent: true);
  print('✅ ProductController registered');

  // ✅ Product Detail Controller
  Get.put<ProductDetailController>(ProductDetailController(repository: Get.find<BaseProductDetailRepository>()), permanent: true);
  print('✅ ProductDetailController registered');

  // Category2 Repository & Controller
  Get.lazyPut<Category2Repository>(
    () => Category2Repository(Get.find<NetworkClient>()),
    fenix: true,
  );
  print('✅ Category2Repository registered');

  Get.lazyPut<Category2Controller>(
    () => Category2Controller(Get.find<Category2Repository>()),
    fenix: true,
  );
  print('✅ Category2Controller registered');

  print('🎉 All dependencies initialized successfully!');

  runApp(const MyApp());
}

// WebView Initialization Function
// Future<void> _initializeWebView() async {
//   try {
//     // Android WebView initialization
//     if (WebViewPlatform.instance != null) {
//       await WebViewPlatform.instance!.initialize();
//       print('✅ WebView Platform initialized successfully');
//     }
//   } catch (e) {
//     print('⚠️ WebView initialization error: $e');
//     // Continue anyway - WebView might still work
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Palli Swad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
        fontFamily: 'Bangla',
      ),
      home: const SplashScreen(),
      defaultTransition: Transition.cupertino,
      opaqueRoute: Get.isPlatformDarkMode,
      popGesture: true,
      
      // Optional: Global configuration for WebView
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // Hide keyboard when tapping outside
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: child,
        );
      },
    );
  }
}