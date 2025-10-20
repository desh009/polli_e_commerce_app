// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/controller/category_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/repository/category_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/controller/categpory_contrpoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/repository/product_1_repository.dart';
import 'package:polli_e_commerce_app/core/widgets/auth_controller.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/Slider_api/controller/slider_api_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/Slider_api/repository/slider_api_repository.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/controller/drwaer_controller.dart';
import 'package:polli_e_commerce_app/ui/splash_screen.dart';

// ✅ নতুন Model এবং Controller import
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔹 NetworkClient inject (singleton)
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
   Get.put<CartController>(CartController(), permanent: true);
Get.lazyPut<ProductRepository>(() => ProductRepository(Get.find<NetworkClient>()), fenix: true);

  /// 🔹 AuthController
  Get.put<AuthController>(AuthController(), permanent: true);

  /// 🔹 Repositories
  Get.put<CategoryRepository>(CategoryRepository(apiClient), permanent: true);
  Get.put<SliderRepository>(
    SliderRepository(networkClient: apiClient),
    permanent: true,
  );

  // ✅ Product2Repository inject
  // Get.put<Product2Repository>(
  //   Product2Repository(networkClient: Get.find<NetworkClient>()),
  //   permanent: true,
  // );

  // /// 🔹 Controllers
  // // ✅ Product2Controller inject - PERMANENT
  // Get.put<Product2Controller>(
  //   Product2Controller(repository: Get.find<Product2Repository>()),
  //   permanent: true,
  // );

  Get.put<Category1Controller>(
    Category1Controller(Get.find<CategoryRepository>()),
    permanent: true,
  );
  
  Get.put<CategoryController>(
    CategoryController(),
    permanent: true,
  );
  
  Get.put<SliderController>(
    SliderController(repository: Get.find<SliderRepository>()),
    permanent: true,
  );
  
  Get.put<DrawerControllerX>(DrawerControllerX(), permanent: true);

  print('🚀 All dependencies initialized successfully');

  runApp(const MyApp());
}

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
    );
  }
}