import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

import 'package:polli_e_commerce_app/screen/widget/ui/gur_screen.dart';
import 'package:polli_e_commerce_app/screen/widget/ui/tel_screen.dart';
import 'package:polli_e_commerce_app/screen/widget/ui/moshla_screen.dart';
import 'package:polli_e_commerce_app/screen/widget/ui/sprcial_item.dart';
import 'package:polli_e_commerce_app/moduls/my_order/view/my_order_view.dart';
import 'package:polli_e_commerce_app/moduls/my_order/bindings/my_order_bindings.dart';
import 'package:polli_e_commerce_app/moduls/my_wishlist/view/my_wish_list_view.dart';
import 'package:polli_e_commerce_app/moduls/my_wishlist/binder/my_wish_list_binder.dart';
import 'package:polli_e_commerce_app/moduls/profile/view/profile_view.dart';
import 'package:polli_e_commerce_app/moduls/profile/binder/profile_binder.dart';
import 'package:polli_e_commerce_app/moduls/settings/view/settings_view.dart';
import 'package:polli_e_commerce_app/moduls/settings/settings_binder/setings_binder.dart';
import 'package:polli_e_commerce_app/moduls/Log_out/view/logout_view.dart';
import 'package:polli_e_commerce_app/moduls/Log_out/binder/log_out_binder.dart';
import 'package:polli_e_commerce_app/ui/home_page/view/home_page.dart';


class CustomDrawer extends StatelessWidget {
  final drawerController = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Amazing Shop"),
              accountEmail: Text("example@email.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.store, color: AppColors.primary, size: 36),
              ),
              decoration: BoxDecoration(color: AppColors.primary),
            ),

            /// Categories
            ExpansionTile(
              leading: Icon(Icons.category, color: AppColors.primary),
              title: Text("Categories"),
              children: [
                ListTile(
                  leading: Icon(Icons.cookie, color: AppColors.primary),
                  title: Text("গুড়"),
                  selected: drawerController.selectedItem.value == "গুড়",
                  selectedTileColor: AppColors.primaryLight,
                  onTap: () {
                    drawerController.selectedItem.value = "গুড়";
                    Get.off(() => GurScreen()); // replace screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.oil_barrel, color: AppColors.primary),
                  title: Text("তেল"),
                  selected: drawerController.selectedItem.value == "তেল",
                  selectedTileColor: AppColors.primaryLight,
                  onTap: () {
                    drawerController.selectedItem.value = "তেল";
                    Get.off(() => TelScreen());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.restaurant_menu, color: AppColors.primary),
                  title: Text("মসলা"),
                  selected: drawerController.selectedItem.value == "মসলা",
                  selectedTileColor: AppColors.primaryLight,
                  onTap: () {
                    drawerController.selectedItem.value = "মসলা";
                    Get.off(() => MoslaScreen());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.star, color: AppColors.primary),
                  title: Text("Special Item"),
                  selected: drawerController.selectedItem.value == "Special Item",
                  selectedTileColor: AppColors.primaryLight,
                  onTap: () {
                    drawerController.selectedItem.value = "Special Item";
                    Get.off(() => SpecialItemScreen());
                  },
                ),
              ],
            ),

            Divider(),

            ListTile(
              leading: Icon(Icons.shopping_cart, color: AppColors.primary),
              title: Text("My Orders"),
              onTap: () {
                Get.to(() => MyOrderView(), binding: MyOrderBinding());
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: AppColors.primary),
              title: Text("Wishlist"),
              onTap: () {
                Get.to(() => WishlistView(), binding: WishlistBinding());
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: AppColors.primary),
              title: Text("Profile"),
              onTap: () {
                Get.to(() => ProfileView(), binding: ProfileBinding());
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: AppColors.primary),
              title: Text("Settings"),
              onTap: () {
                Get.to(() => SettingsView(), binding: SettingsBinding());
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout"),
              onTap: () {
                Get.to(() => LogoutView(), binding: LogoutBinding());
              },
            ),
          ],
        ),
      ),
    );
  }
}
