import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/controller/categpory_contrpoller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/view/category_screen.dart';
import 'package:polli_e_commerce_app/ui/featured_option.dart.dart';
import 'package:polli_e_commerce_app/ui/home_page/Slider_api/controller/slider_api_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/controller/drwaer_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/view/drawer_view.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/favourite_pages/favourite_pages.dart';
import 'package:polli_e_commerce_app/ui/latest_products.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // ✅ CORRECT: শুধু Get.find() ব্যবহার করুন
  final drawerController = Get.find<DrawerControllerX>();
  final categoryController = Get.find<CategoryController>(); // ✅ CategoryController
  final sliderController = Get.find<SliderController>();

  final List<Map<String, dynamic>> features = [
    {"icon": Icons.local_shipping, "text": "Delivery"},
    {"icon": Icons.verified, "text": "Authentic"},
    {"icon": Icons.support_agent, "text": "Support"},
    {"icon": Icons.star, "text": "Top Rated"},
  ];

  final List<Map<String, dynamic>> staticCategories = [
    {"name": "গুড়", "items": 12, "image": "assets/images/gur.jpg"},
    {
      "name": "মধু",
      "items": 8,
      "image": "assets/images/honey-png-hd-suzme-bal-500.png",
    },
    {"name": "তেল", "items": 5, "image": "assets/images/tel.jpeg"},
    {"name": "মসলা", "items": 10, "image": "assets/images/mosla.png"},
    {"name": "Special", "items": 6, "image": "assets/images/special_item.png"},
  ];

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
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            /// ================= Slider Section =================
            Obx(() {
              print('🔄 Slider State - Loading: ${sliderController.isLoading.value}, Count: ${sliderController.sliders.length}');
              
              if (sliderController.isLoading.value) {
                return Container(
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (sliderController.sliders.isEmpty) {
                return Container(
                  height: 220,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.slideshow, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'কোনো স্লাইডার পাওয়া যায়নি',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          // ✅ FIX: Proper function call
                          onPressed: () {
                            sliderController.fetchSliders();
                          },
                          child: Text('রিট্রাই করুন'),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: sliderController.sliders.length,
                      itemBuilder: (context, index, realIndex) {
                        final slider = sliderController.sliders[index];
                        final imageUrl = "https://inventory.growtech.com.bd/${slider.mobileImg}";

                        print('🖼️ Loading slider image: $imageUrl');

                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => CategoryScreen(
                                initialSelectedCategory: slider.title,
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[200],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 220,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  print('❌ Slider image error: $error');
                                  return Container(
                                    height: 220,
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image, size: 50, color: Colors.grey[500]),
                                          SizedBox(height: 8),
                                          Text(
                                            'ইমেজ লোড হয়নি',
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 220,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.95,
                        autoPlayInterval: Duration(seconds: 5),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${sliderController.sliders.length}টি স্লাইডার',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                );
              }
            }),

            SizedBox(height: 20),

            /// ================= Features Section =================
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
                      Text(
                        f["text"],
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 20),

            /// ================= Popular Categories (API) =================
            _sectionTitle("Popular Categories"),
            Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Obx(() {
                print('🔄 Categories State - Loading: ${categoryController.isLoading.value}, Count: ${categoryController.categories.length}');
                
                if (categoryController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (categoryController.categories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.category, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("কোনো ক্যাটাগরি পাওয়া যায়নি"),
                        SizedBox(height: 10),
                        ElevatedButton(
                          // ✅ FIX: Proper function call
                          onPressed: () {
                            categoryController.fetchCategories();
                          },
                          child: Text("আবার চেষ্টা করুন"),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryController.categories.length,
                    separatorBuilder: (_, __) => SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final cat = categoryController.categories[index];
                      
                      // ✅ API থেকে আসা categories (Map format)
                      final categoryName = cat['title']?.toString() ?? 'No Name';
                      final categoryId = cat['id']?.toString() ?? '';

                      return InkWell(
                        onTap: () {
                          print('🎯 Category tapped: $categoryName (ID: $categoryId)');
                          Get.to(
                            () => CategoryScreen(
                              initialSelectedCategory: categoryName,
                            ),
                          );
                        },
                        child: Container(
                          width: 110,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // ✅ Category Image (API থেকে)
                              Container(
                                height: 80,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: _buildCategoryImage(cat),
                              ),
                              SizedBox(height: 6),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  categoryName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'ID: $categoryId',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),

            SizedBox(height: 30),

            /// ================= Featured Options (Static) =================
            _sectionTitle("Featured Options"),
            FeaturedOption(categories: staticCategories),

            SizedBox(height: 30),

            /// ================= Latest Products (Static) =================
            _sectionTitle("Latest Products"),
            LatestProducts(products: latestProducts),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ✅ Category Image Builder
  Widget _buildCategoryImage(Map<String, dynamic> category) {
    final hasImage = category['image'] != null && category['image'].toString().isNotEmpty;
    
    if (hasImage) {
      final imageUrl = "https://inventory.growtech.com.bd/${category['image']}";
      print('🖼️ Category image URL: $imageUrl');
      
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildCategoryPlaceholder();
          },
        ),
      );
    } else {
      return _buildCategoryPlaceholder();
    }
  }

  // ✅ Category Placeholder
  Widget _buildCategoryPlaceholder() {
    return Center(
      child: Icon(
        Icons.category,
        color: AppColors.primary,
        size: 40,
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

// // ✅ DrawerControllerX আলাদা file এ রাখুন (lib/ui/home_page/drawer/controller/drawer_controller.dart)
// class DrawerControllerX extends GetxController {
//   var selectedItem = "".obs;
//   var cartCount = 0.obs;
// }