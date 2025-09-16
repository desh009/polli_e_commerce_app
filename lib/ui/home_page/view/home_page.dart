import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/category_screen.dart';
import 'package:polli_e_commerce_app/ui/featured_option.dart.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/view/drawer_view.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/latest_products.dart';

class DrawerControllerX extends GetxController {
  var selectedItem = "".obs;
}

class HomePage extends StatelessWidget {
  final drawerController = Get.put(DrawerControllerX());
  final List<Map<String, String>> carouselItems = [
    {
      "image": "https://i.ibb.co/4pDJp3S/turmeric.jpg",
      "title": "গুড়",
      "subtitle": "খাঁটি গুড়, স্বাদের মুহূর্তের সঙ্গী",
    },

    {
      "image": "https://i.ibb.co/R9B3c2K/honey.jpg",
      "title": "মধু",
      "subtitle": "খাঁটি মধু, প্রকৃতির উপহার",
    },
    
    {
      "image": "https://i.ibb.co/m8bRL1H/mustard-oil.jpg",
      "title": "তেল",
      "subtitle": "খাঁটি সরিষার তেল, স্বাস্থ্যকর রান্নার সঙ্গী",
    },
  ];
  final List<Map<String, dynamic>> features = [
    {"icon": Icons.local_shipping, "text": "Delivery"},
    {"icon": Icons.verified, "text": "Authentic"},
    {"icon": Icons.support_agent, "text": "Support"},
    {"icon": Icons.star, "text": "Top Rated"},
  ];
  final List<Map<String, dynamic>> categories = [
    {"name": "গুড়", "items": 12},
    {"name": "মধু", "items": 8},
    {"name": "তেল", "items": 5},
    {"name": "মসলা", "items": 10},
    {"name": "Special", "items": 6},
    {"name": "Extra 1", "items": 3},
    {"name": "Extra 2", "items": 4},
  ];
  final List<Map<String, dynamic>> latestProducts = List.generate(15, (index) {
    return {
      "name": "Product ${index + 1}",
      "items": (index + 1) * 2,
      "image": null,
    };
  });

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
            IconButton(
              icon: Icon(Icons.favorite, color: AppColors.primary),
              onPressed: () {},
            ),
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: AppColors.primary),
                  onPressed: () {},
                ),
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
                      '0',
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
          ],
        ),
      ),
      
      drawer: CustomDrawer(
        onSelectCategory: (String category, String? option) {
          Navigator.pop(context);
          Get.to(() => CategoryScreen(
                initialSelectedCategory: category,
                initialSelectedOption: option,
              ));
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    /// Carousel Slider
                    CarouselSlider.builder(
                      itemCount: carouselItems.length,
                      itemBuilder: (context, index, realIndex) {
                        final item = carouselItems[index];
                        return Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(item["image"]!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["title"]!,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    item["subtitle"]!,
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                  SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.to(() => CategoryScreen(
                                              initialSelectedOption: item["title"]!,
                                            ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                      ),
                                      child: Text("Order Now"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                        height: 220,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.95,
                      ),
                    ),
                    SizedBox(height: 20),
                    /// Features Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: features.map((f) {
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: AppColors.primaryLight,
                                child: Icon(f["icon"], color: AppColors.primary),
                              ),
                              SizedBox(height: 6),
                              Text(f["text"]),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    /// Popular Categories Section (Scrollable)
                    _sectionTitle("Popular Categories"),
                    Container(
                      height: 120,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (context, index) => SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          return InkWell(
                            onTap: () {
                              Get.to(() => CategoryScreen(
                                    initialSelectedCategory: cat["name"],
                                  ));
                            },
                            child: Container(
                              width: 100,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image, size: 36, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text(
                                    cat["name"],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text("${cat["items"]} items", textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    /// Featured Options
                    _sectionTitle("Featured Options"),
                    FeaturedOption(categories: categories),
                    SizedBox(height: 30),
                    /// Latest Products
                    _sectionTitle("Latest Products"),
                    LatestProducts(products: latestProducts),
                    SizedBox(height: 20), // Extra padding at bottom
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
