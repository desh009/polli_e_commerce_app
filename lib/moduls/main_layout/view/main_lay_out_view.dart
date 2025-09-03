import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polli_e_commerce_app/moduls/Log_out/binder/log_out_binder.dart';
import 'package:polli_e_commerce_app/moduls/Log_out/view/logout_view.dart';
import 'package:polli_e_commerce_app/moduls/main_layout/controller/main_layout_controller.dart';
import 'package:polli_e_commerce_app/moduls/my_order/bindings/my_order_bindings.dart';
import 'package:polli_e_commerce_app/moduls/my_order/view/my_order_view.dart';
import 'package:polli_e_commerce_app/moduls/my_wishlist/binder/my_wish_list_binder.dart';
import 'package:polli_e_commerce_app/moduls/my_wishlist/view/my_wish_list_view.dart';
import 'package:polli_e_commerce_app/moduls/profile/binder/profile_binder.dart';
import 'package:polli_e_commerce_app/moduls/profile/view/profile_view.dart';
import 'package:polli_e_commerce_app/moduls/settings/settings_binder/setings_binder.dart';
import 'package:polli_e_commerce_app/moduls/settings/view/settings_view.dart';
import 'package:polli_e_commerce_app/ui/home_page/bindings/home_page_bindings.dart';
import 'package:polli_e_commerce_app/ui/home_page/view/home_page.dart';

class MainLayoutView extends GetView<MainLayoutController> {
  MainLayoutView({Key? key}) : super(key: key);

  final List<DrawerItem> drawerItems = [
    DrawerItem(
      title: "Home",
      icon: Icons.home,
      page: HomePage(),
      binding: HomeBinding(),
    ),
    DrawerItem(
      title: "My Orders",
      icon: Icons.shopping_cart,
      page: const MyOrderView(),
      binding: MyOrderBinding(),
    ),
    DrawerItem(
      title: "Wish List",
      icon: Icons.favorite,
      page: WishlistView(),
      binding: WishlistBinding(),
    ),
    DrawerItem(
      title: "Profile",
      icon: Icons.person,
      page: const ProfileView(),
      binding: ProfileBinding(),
    ),
    DrawerItem(
      title: "Settings",
      icon: Icons.settings,
      page: const SettingsView(),
      binding: SettingsBinding(),
    ),
    DrawerItem(
      title: "Logout",
      icon: Icons.logout,
      page: const LogoutView(),
      binding: LogoutBinding(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLayoutController>(
      init: controller,
      builder: (context) {
        return Obx(
          () => Scaffold(
            key: controller.mainLayoutKey,
            appBar: AppBar(
              title: const Text("Polli E-Commerce"),
              centerTitle: true,
              backgroundColor: Colors.blue,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        "Polli E-Commerce",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: drawerItems
                        .map(
                          (e) => ListTile(
                            leading: Icon(
                              e.icon,
                              size: 24,
                              color: controller.currentIndex.value ==
                                      drawerItems.indexOf(e)
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            title: Text(
                              e.title,
                              style: TextStyle(
                                color: controller.currentIndex.value ==
                                        drawerItems.indexOf(e)
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                            onTap: () {
                              if (e.title == "Logout") {
                                controller.logout();
                                return;
                              } else {
                                controller.changePage(drawerItems.indexOf(e));
                              }
                              Get.back();
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            body: PageView.builder(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: drawerItems.length,
              itemBuilder: (context, index) {
                drawerItems[index].binding!.dependencies();
                return drawerItems[index].page!;
              },
            ),
          ),
        );
      },
    );
  }
}

class DrawerItem {
  final String title;
  final IconData icon;
  final Widget? page;
  final Bindings? binding;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.page,
    required this.binding,
  });
}
