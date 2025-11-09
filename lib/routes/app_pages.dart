import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/controller/add_to_cart_contoller.dart';
import 'package:polli_e_commerce_app/core/screen/add_To_cart_screen/view/add_to_cart_scree.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/binder/chek_out_binder.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/check_out_screen/view/chek_out_view.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/binder/registration_binder.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/view/registrtion_view.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/view/Login_screen.dart';
import 'package:polli_e_commerce_app/moduls/Log_out/binder/log_out_binder.dart';
import 'package:polli_e_commerce_app/moduls/Log_out/view/logout_view.dart';
import 'package:polli_e_commerce_app/moduls/main_layout/bindings/main_layout_bindings.dart';
import 'package:polli_e_commerce_app/moduls/main_layout/view/main_lay_out_view.dart';
import 'package:polli_e_commerce_app/moduls/my_order/bindings/my_order_bindings.dart';
import 'package:polli_e_commerce_app/moduls/my_order/view/My_order_view.dart';
import 'package:polli_e_commerce_app/moduls/my_wishlist/binder/my_wish_list_binder.dart';
import 'package:polli_e_commerce_app/moduls/my_wishlist/view/my_wish_list_view.dart';
import 'package:polli_e_commerce_app/moduls/profile/binder/profile_binder.dart';
import 'package:polli_e_commerce_app/moduls/profile/view/profile_view.dart';
import 'package:polli_e_commerce_app/moduls/settings/settings_binder/setings_binder.dart';
import 'package:polli_e_commerce_app/moduls/settings/view/settings_view.dart';
import 'package:polli_e_commerce_app/ui/home_page/bindings/home_page_bindings.dart';
import 'package:polli_e_commerce_app/ui/home_page/view/home_page.dart';

part 'app_rutes.dart';

class AppPages {
  AppPages._();
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // GetPage(
    //   name: _Paths.SPLASH,
    //   page: () => const SplashView(),
    //   binding: SplashBinding(),
    // ),
    // GetPage(
    //   name: _Paths.INTRO,
    //   page: () => const IntroView(),
    //   binding: IntroBinding(),
    // ),
    // GetPage(
    //   name: _Paths.AUTH,
    //   page: () => const AuthView(),
    //   binding: AuthBinding(),
    // ),
    // main.dart এর GetPages তালিকায় এড করুন
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => CheckoutScreen(),
      binding: CheckoutBinding(),
    ),
    // lib/routes/app_pages.dart
    GetPage(name: _Paths.LOGIN, page: () => const LoginScreen()),

    // ✅ সাইন আপ রাউট যোগ করুন
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => SignUpScreen(),
      binding: RegistrationBinding(),
    ),    GetPage(
      name: _Paths.MAIN_LAYOUT,
      page: () => MainLayoutView(),
      binding: MainLayoutBinding(),
    ),
    GetPage(name: _Paths.HOME, page: () => HomePage(), binding: HomeBinding()),
    GetPage(
      name: _Paths.MY_ORDER,
      page: () => const MyOrderView(),
      binding: MyOrderBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.MY_WISHLIST,
      page: () => const WishlistView(),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.LOGOUT,
      page: () => const LogoutView(),
      binding: LogoutBinding(),
    ),
    // GetPage(
    //   name: _Paths.OTP_VERIFICATION,
    //   page: () => OtpVerificationScreen(
    //     email: Get.arguments['email'] ?? '',
    //     phone: Get.arguments['phone'] ?? '',
    //   ),
    // ),
    GetPage(
      name: Routes.CART,
      page: () => CartScreen(product: {}),
      binding: BindingsBuilder(() {
        Get.lazyPut<CartController>(() => CartController());
      }),
    ),
    // main.dart এ এই লাইনগুলো এড করুন

    // GetMaterialApp এর মধ্যে
    GetPage(
        name: _Paths.CHECKOUT,

      page: () => CheckoutScreen(),
      binding: CheckoutBinding(),
    ),
    // lib/app_pages.dart - final version
  // GetPage(
  //   name: _Paths.OTP_VERIFICATION,
  //   page: () {
  //     // arguments check করুন
  //     if (Get.arguments != null && Get.arguments is Map) {
  //       final args = Get.arguments as Map;
  //       return OtpVerificationScreen(
  //         email: args['email']?.toString() ?? '',
  //         phone: args['phone']?.toString() ?? '',
  //       );
  //     } else {
  //       // Fallback values
  //       return const OtpVerificationScreen(
  //         email: 'user@example.com',
  //         phone: '01700000000',
  //       );
  //     }
  //   },
  // ),
    // GetPage(
    // //   name: _Paths.FORGOT_PASSWORD,
    //   page: () => ForgotPasswordView(),
    //   binding: ForgotPasswordBinding(),
    // ),
    // GetPage(
    //   name: _Paths.CHANGE_PASSWORD,
    //   page: () => ChangePasswordView(),
    //   binding: ChangePasswordBinding(),
    // ),
    // GetPage(
    //   name: _Paths.DASHBOARD,
    //   page: () => const DashboardScreen(),
    //   binding: DashboardBindings(),
    // ),
    // GetPage(
    //   name: _Paths.CAR_ROUTE,
    //   page: () => const CarRouteView(),
    //   binding: CarRouteBinding(),
    // ),
  ];
}
