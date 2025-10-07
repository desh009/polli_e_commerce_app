import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/controller/category_controller.dart';
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
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Amazing Shop"),
            accountEmail: const Text("example@email.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.store, color: AppColors.primary, size: 36),
            ),
            decoration: BoxDecoration(color: AppColors.primary),
          ),

          // Categories
          ExpansionTile(
            leading: Icon(Icons.category, color: AppColors.primary),
            title: const Text("Categories"),
            children: [
              Obx(() {
                if (categoryController.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (categoryController.error.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Error: ${categoryController.error.value}"),
                  );
                } else if (categoryController.categories.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No categories found"),
                  );
                } else {
                  return Column(
                    children: categoryController.categories.map((category) {
                      return _buildCategory(
                        context,
                        categoryName: category.title,
                        icon: Icons.category,
                        options: [], // Subcategory support future
                      );
                    }).toList(),
                  );
                }
              }),
            ],
          ),

          const Divider(),

          ListTile(
            leading: Icon(Icons.home, color: AppColors.primary),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Get.offAll(() => HomePage());
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart, color: AppColors.primary),
            title: const Text("My Orders"),
            onTap: () {
              Get.to(() => MyOrderView(), binding: MyOrderBinding());
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: AppColors.primary),
            title: const Text("Wishlist"),
            onTap: () {
              Get.to(() => WishlistView(), binding: WishlistBinding());
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: AppColors.primary),
            title: const Text("Profile"),
            onTap: () {
              Get.to(() => ProfileView(), binding: ProfileBinding());
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: AppColors.primary),
            title: const Text("Settings"),
            onTap: () {
              Get.to(() => SettingsView(), binding: SettingsBinding());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {
              Get.to(() => LogoutView(), binding: LogoutBinding());
            },
          ),
        ],
      ),
    );
  }

  // Category item builder
  Widget _buildCategory(
    BuildContext context, {
    required String categoryName,
    required IconData icon,
    List<String>? options,
  }) {
    if (options == null || options.isEmpty) {
      return ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(categoryName),
        onTap: () {
          print("Selected category: $categoryName");
          if (Get.currentRoute.contains('CategoryScreen')) {
            widget.onSelectCategory(categoryName, null);
          } else {
            Navigator.pop(context);
            Get.to(
              () => CategoryScreen(
                key: UniqueKey(),
                initialSelectedCategory: categoryName,
              ),
            );
          }
        },
      );
    }

    // Subcategory support
    return ExpansionTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(categoryName),
      children: [
        ...options.map(
          (option) => ListTile(
            contentPadding: const EdgeInsets.only(left: 72),
            title: Text(option),
            onTap: () {
              print("Selected option: $option from $categoryName");
              if (Get.currentRoute.contains('CategoryScreen')) {
                widget.onSelectCategory(categoryName, option);
              } else {
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
        const Divider(),
        ListTile(
          contentPadding: const EdgeInsets.only(left: 72),
          leading: Icon(Icons.list, size: 16, color: AppColors.primary),
          title: Text(
            "সব $categoryName দেখুন",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            print("See all selected: $categoryName");
            if (Get.currentRoute.contains('CategoryScreen')) {
              widget.onSelectCategory(categoryName, null);
            } else {
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