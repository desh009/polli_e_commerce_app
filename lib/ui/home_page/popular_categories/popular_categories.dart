import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/view/category_screen.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class PopularCategories extends StatelessWidget {
  // ক্যাটাগরির ডেটা (নাম + ইমেজ)
  final List<Map<String, String>> categories = [
    {"name": "গুড়", "image": "assets/images/gur.jpg"},
    {"name": "মধু", "image": "assets/images/about-honey.jpg"},
    {"name": "তেল", "image": "assets/images/tel.jpeg"},
    {"name": "মসলা", "image": "assets/images/mosla.png"},
    {"name": "Special Item", "image": "assets/images/special_item.png"},
  ];

  PopularCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(

      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // ২ কলাম হবে
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            // ক্যাটাগরি ক্লিক হলে CategoryScreen-এ যাবে
            Get.to(
              () => CategoryScreen(
                key: ValueKey(category['name']),
                initialSelectedCategory: category['name'],
              ),
            );
          },
          
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      category['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  category['name']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }
}
