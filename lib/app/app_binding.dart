import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/controller/category_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/repository/category_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/controller/categpory_contrpoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/Registration_otp/controller/registration_otp_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/Registration_otp/repository/registration_otp_repo.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/controller/registration_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/repository/registration_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/controller/login_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/controller/product_1_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/response/repository/product_1_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_2_response/response/product_2_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_2_response/response/repository/product_2_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/controller/chek_out_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/repository/chek_out_repository.dart';
import 'package:polli_e_commerce_app/core/widgets/auth_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/Screens/favourite_pages/controller/favourite_page_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/Slider_api/controller/slider_api_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/Slider_api/repository/slider_api_repository.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/controller/2nd_category_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/repository/2nd_category_repository.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/Screens/profile_screen/controller/profile_update_screen_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/controller/drwaer_controller.dart';

// ✅ NEW: OTP related imports


class AppBinding implements Bindings {
  @override
  void dependencies() {
    _initializeNetworkClient();
    _initializeAuthControllers();
    _initializeCartController();
    _initializeRegistrationSetup();
    _initializeOTPSetup();
    _initializeOtherRepositories();
    _initializeOtherControllers();
  }

  void _initializeNetworkClient() {
    final apiClient = NetworkClient(
      onUnAuthorize: () {
        print("🔐 Unauthorized! Redirect to login...");
        try {
          final authController = Get.find<EpicAuthController>();
          authController.executeUserLogout();
        } catch (e) {
          print('❌ Error in onUnAuthorize: $e');
        }
      },
      commonHeaders: () {
        final headers = {
          "Content-Type": "application/json",
          "Accept": "application/json",
        };

        try {
          final authController = Get.find<EpicAuthController>();
          if (authController.authToken.isNotEmpty) {
            headers['Authorization'] = 'Bearer ${authController.authToken.value}';
          }
        } catch (e) {
          // Silent catch
        }

        return headers;
      },
    );
    Get.put<NetworkClient>(apiClient, permanent: true);
    print('✅ NetworkClient registered');
  }

  void _initializeAuthControllers() {
    Get.put<EpicAuthController>(EpicAuthController(), permanent: true);
    print('✅ EpicAuthController registered');

    Get.put(AuthController(), permanent: true);
    print('✅ AuthController registered');
  }

  void _initializeCartController() {
    Get.put(CartController(), permanent: true);
    print('✅ CartController registered');
  }

  void _initializeRegistrationSetup() {
    // Registration Repository
  Get.lazyPut<RegistrationRepository>(
    () => RegistrationRepository(networkClient: 
        Get.find<NetworkClient>()
    ), // Remove networkClient parameter
    fenix: true,
  );
  print('✅ RegistrationRepository registered');
    
    print('✅ RegistrationRepository registered');

    // Registration Controller
    Get.lazyPut<RegistrationController>(
      () => RegistrationController(),
      fenix: true,
    );
    print('✅ RegistrationController registered');
  }

  void _initializeOTPSetup() {
    // User ZX Repository
    Get.lazyPut<UserZxRepository>(
      () => UserZxRepository(),
      fenix: true,
    );
    print('✅ UserZxRepository registered');

    // User ZX Controller
    Get.lazyPut<UserZxController>(
      () => UserZxController(),
      fenix: true,
    );
    print('✅ UserZxController registered');
  }

  void _initializeOtherRepositories() {
    // Category1 Repository
    Get.lazyPut<Category1Repository>(
      () => Category1Repository(Get.find<NetworkClient>()),
      fenix: true,
    );
    print('✅ Category1Repository registered');

    // Slider Repository
    Get.put<SliderRepository>(
      SliderRepository(networkClient: Get.find<NetworkClient>()),
      permanent: true,
    );
    print('✅ SliderRepository registered');

    // Product Repository
    Get.put<BaseProductRepository>(
      ProductRepository(Get.find<NetworkClient>()),
      permanent: true,
    );
    print('✅ BaseProductRepository registered');

    // Checkout Repository
    Get.lazyPut<CheckoutRepository>(
      () => CheckoutRepository(networkClient: Get.find<NetworkClient>()),
      fenix: true,
    );
    print('✅ CheckoutRepository registered');

    // Product Detail Repository
    Get.put<BaseProductDetailRepository>(
      ProductDetailRepository(networkClient: Get.find<NetworkClient>()),
      permanent: true,
    );
    print('✅ BaseProductDetailRepository registered');

    // Category2 Repository
    Get.lazyPut<Category2Repository>(
      () => Category2Repository(Get.find<NetworkClient>()),
      fenix: true,
    );
    print('✅ Category2Repository registered');
  }

  void _initializeOtherControllers() {
    // Favourite Controller
    Get.lazyPut<FavouriteController>(() => FavouriteController(), fenix: true);
    print('✅ FavouriteController registered');

    // Category1 Controller
    Get.lazyPut<Category1Controller>(
      () => Category1Controller(Get.find<Category1Repository>()),
      fenix: true,
    );
    print('✅ Category1Controller registered');

    // Category Controller
    Get.put<CategoryController>(CategoryController(), permanent: true);
    print('✅ CategoryController registered');

    // Slider Controller
    Get.put<SliderController>(
      SliderController(repository: Get.find<SliderRepository>()),
      permanent: true,
    );
    print('✅ SliderController registered');

    // Drawer Controller
    Get.put<DrawerControllerX>(DrawerControllerX(), permanent: true);
    print('✅ DrawerControllerX registered');

    // Product Controller
    Get.put<ProductController>(
      ProductController(repository: Get.find<BaseProductRepository>()),
      permanent: true,
    );
    print('✅ ProductController registered');

    // Product Detail Controller
    Get.put<ProductDetailController>(
      ProductDetailController(
        repository: Get.find<BaseProductDetailRepository>(),
      ),
      permanent: true,
    );
    print('✅ ProductDetailController registered');

    // Checkout Controller
    Get.put(
      CheckoutController(
        checkoutRepository: Get.find<CheckoutRepository>(),
        cartController: Get.find<CartController>(),
      ),
      permanent: true,
    );
    print('✅ CheckoutController registered');

    // Category2 Controller
    Get.lazyPut<Category2Controller>(
      () => Category2Controller(Get.find<Category2Repository>()),
      fenix: true,
    );
    print('✅ Category2Controller registered');

    // Profile Controller
    Get.put(ProfileXController(), permanent: true);
    print('✅ ProfileXController registered');
  }
}