import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/view/category_screen.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

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

class CustomDrawer extends StatefulWidget {
  final String? initialSelectedCategory;
  final String? initialSelectedOption;
  final Function(String category, String? option) onSelectCategory;

  const CustomDrawer({
    super.key,
    required this.onSelectCategory,
    this.initialSelectedCategory,
    this.initialSelectedOption,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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

          /// Categories with sub-items
          ExpansionTile(
            leading: Icon(Icons.category, color: AppColors.primary),
            title: Text("Categories"),
            children: [
              _buildCategory(
                context,
                categoryName: "গুড়",
                icon: Icons.cookie,
                options: [
                  "ঘোলা গুড়",
                  "বিজ গুড়",
                  "নারকেল গুড়",
                  "দানাদার গুড়",
                  "চকলেট গুড়",
                  "পাটালি গুড়",
                ],
              ),
              _buildCategory(
                context,
                categoryName: "তেল",
                icon: Icons.oil_barrel,
                options: ["নারকেল তেল", "সরিষা তেল"],
              ),
              _buildCategory(
                context,
                categoryName: "মসলা",
                icon: Icons.restaurant_menu,
                options: ["মরিচ", "হলুদ", "জিরা", "ধনিয়া", "গরম মশলা"],
              ),
              _buildCategory(
                context,
                categoryName: "Special Item",
                icon: Icons.star,
                options: ["খোলিসা মধু", "কুমড়ো বরি", "ঘি", "চালের গুড়া"],
              ),
            ],
          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.home, color: AppColors.primary),
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Get.offAll(
                () => HomePage(),
              ); // এখানে চাইলে তোমার HomePage widget বসাও
            },
          ),

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
    );
  }

  /// Generic method for building categories with options
  Widget _buildCategory(
    BuildContext context, {
    required String categoryName,
    required IconData icon,
    required List<String> options,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(categoryName),
      children: [
        // Individual options
        ...options.map(
          (option) => ListTile(
            contentPadding: EdgeInsets.only(left: 72),
            title: Text(option),
            onTap: () {
              print(
                "Selected individual option: $option from $categoryName",
              ); // Debug

              // Check if we're currently on CategoryScreen
              if (Get.currentRoute.contains('CategoryScreen')) {
                // ✅ Update existing screen
                widget.onSelectCategory(categoryName, option);
              } else {
                // ✅ Navigate to new CategoryScreen
                Navigator.pop(context);
                Get.to(
                  () => CategoryScreen(
                    key: ValueKey('$categoryName-$option'),
                    initialSelectedCategory: categoryName,
                  ),
                );
              }
            },
          ),
        ),
        Divider(),
        // "See All" option
        ListTile(
          contentPadding: EdgeInsets.only(left: 72),
          leading: Icon(Icons.list, size: 16, color: AppColors.primary),
          title: Text(
            "সব $categoryName দেখুন",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            print("See all selected: $categoryName"); // Debug

            // Check if we're currently on CategoryScreen
            if (Get.currentRoute.contains('CategoryScreen')) {
              // ✅ Update existing screen
              widget.onSelectCategory(categoryName, null);
            } else {
              // ✅ Navigate to new CategoryScreen
              Navigator.pop(context);
              Get.to(
                () => CategoryScreen(
                  key: UniqueKey(),
                  initialSelectedCategory: categoryName,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
