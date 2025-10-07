import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/view/category_screen.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/view/drawer_view.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

// Dummy pages
class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favourites")),
      body: Center(child: Text("Your favourite products will appear here.")),
    );
  }
}


class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Center(child: Text("Your cart items will appear here.")),
    );
  }
}

class DrawerControllerX extends GetxController {
  var selectedItem = "".obs;
  var cartCount = 0.obs; // Cart badge
}

class HomePage extends StatelessWidget {
  final drawerController = Get.put(DrawerControllerX());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: AppColors.primary),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for products',
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(width: 10),
            // Favourite Button
            IconButton(
              icon: Icon(Icons.favorite, color: AppColors.primary),
              onPressed: () {
                Get.to(() => const FavouritePage());
              },
            ),
            // Cart Button with badge
            Obx(
              () => Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: AppColors.primary),
                    onPressed: () {
                      Get.to(() => const CartPage());
                    },
                  ),
                  if (drawerController.cartCount.value > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${drawerController.cartCount.value}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(
        onSelectCategory: (String category, String? option) {
          Navigator.pop(context);
          Get.to(
            () => CategoryScreen(
              initialSelectedCategory: category,
              initialSelectedOption: option,
            ),
          );
        },
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            drawerController.cartCount.value +=
                1; // Sample: increase cart count
          },
          child: Text("Add item to cart"),
        ),
      ),
    );
  }
}
