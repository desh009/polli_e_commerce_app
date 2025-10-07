import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/view/category_screen.dart';
import 'package:polli_e_commerce_app/ui/featured_option.dart.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/view/drawer_view.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/favourite_pages/favourite_pages.dart';
import 'package:polli_e_commerce_app/ui/latest_products.dart';

class DrawerControllerX extends GetxController {
  var selectedItem = "".obs;
  var cartCount = 0.obs;
}

class HomePage extends StatelessWidget {
  final drawerController = Get.put(DrawerControllerX());

  HomePage({super.key});

  /// ================= Carousel Items =================
  final List<Map<String, String>> carouselItems = [
    {
      "image": "assets/images/gur.jpg",
      "title": "গুড়",
      "subtitle": "খাঁটি গুড়, স্বাদের মুহূর্তের সঙ্গী",
    },
    {
      "image": "assets/images/honey-png-hd-suzme-bal-500.png",
      "title": "মধু",
      "subtitle": "খাঁটি মধু, প্রকৃতির উপহার",
    },
    {
      "image": "assets/images/tel.jpeg",
      "title": "তেল",
      "subtitle": "খাঁটি সরিষার তেল, স্বাস্থ্যকর রান্নার সঙ্গী",
    },
  ];

  /// ================= Features =================
  final List<Map<String, dynamic>> features = [
    {"icon": Icons.local_shipping, "text": "Delivery"},
    {"icon": Icons.verified, "text": "Authentic"},
    {"icon": Icons.support_agent, "text": "Support"},
    {"icon": Icons.star, "text": "Top Rated"},
  ];

  /// ================= Categories =================
  final List<Map<String, dynamic>> categories = [
    {"name": "গুড়", "items": 12, "image": "assets/images/gur.jpg"},
    {"name": "মধু", "items": 8, "image": "assets/images/honey-png-hd-suzme-bal-500.png"},
    {"name": "তেল", "items": 5, "image": "assets/images/tel.jpeg"},
    {"name": "মসলা", "items": 10, "image": "assets/images/mosla.png"},
    {"name": "Special", "items": 6, "image": "assets/images/special_item.png"},
  ];

  /// ================= Latest Products =================
  final List<Map<String, dynamic>> latestProducts = List.generate(15, (index) {
    return {
      "name": "Product ${index + 1}",
      "items": (index + 1) * 2,
      "image": null,
    };
  });

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
            IconButton(
              icon: Icon(Icons.favorite, color: AppColors.primary),
              onPressed: () {
                Get.to(() => const FavouritePage());
              },
            ),
            Obx(() => Stack(
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
                          constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Text(
                            '${drawerController.cartCount.value}',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                )),
          ],
        ),
      ),
      drawer: CustomDrawer(
        onSelectCategory: (String category, String? option) {
          Navigator.pop(context);
          Get.to(
            () => CategoryScreen(initialSelectedCategory: category, initialSelectedOption: option),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            /// ================= Carousel Slider =================
            CarouselSlider.builder(
              itemCount: carouselItems.length,
              itemBuilder: (context, index, realIndex) {
                final item = carouselItems[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => CategoryScreen(
                          initialSelectedCategory: item["title"],
                          initialSelectedOption: item["title"],
                        ));
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item["image"]!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 220,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"]!,
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.accent),
                            ),
                            SizedBox(height: 8),
                            Text(
                              item["subtitle"]!,
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              options: CarouselOptions(height: 220, autoPlay: true, enlargeCenterPage: true, viewportFraction: 0.95),
            ),

            SizedBox(height: 20),

            /// ================= Features Section =================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: features.map((f) {
                    return Column(
                      children: [
                        CircleAvatar(radius: 28, backgroundColor: AppColors.primaryLight, child: Icon(f["icon"], color: AppColors.primary)),
                        SizedBox(height: 6),
                        Text(f["text"]),
                      ],
                    );
                  }).toList()),
            ),

            SizedBox(height: 20),

            /// ================= Popular Categories =================
            _sectionTitle("Popular Categories"),
            Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return InkWell(
                    onTap: () {
                      Get.to(() => CategoryScreen(initialSelectedCategory: cat["name"]));
                    },
                    child: Container(
                      width: 110,
                      decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              cat["image"],
                              height: 80,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(cat["name"], style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("${cat["items"]} items", style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 30),

            /// ================= Featured Options =================
            _sectionTitle("Featured Options"),
            FeaturedOption(categories: categories),

            SizedBox(height: 30),

            /// ================= Latest Products =================
            /// 
            /// ===============================
            _sectionTitle("Latest Products"),
            LatestProducts(products: latestProducts),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
    );
  }
}
