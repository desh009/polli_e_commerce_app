import 'package:flutter/material.dart';
import 'package:polli_e_commerce_app/core/screen/category_screen.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/view/drawer_view.dart';

class GurScreen extends StatelessWidget {
  const GurScreen({super.key});

  final List<Map<String, dynamic>> gurItems = const [
    {"name": "বিজ গুড়", "items": 10},
    {"name": "দানাদার গুড়", "items": 8},
    {"name": "নারকেল গুড়", "items": 12},
    {"name": "ঘোলা গুড়", "items": 5},
    {"name": "চকলেট গুড়", "items": 7},
    {"name": "পাতালি গুড়", "items": 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("গুড় Categories"),
        centerTitle: true,
        backgroundColor: AppColors.primaryLight,
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: gurItems.map((item) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 36) / 2,
              child: InkWell(
                onTap: () {
                  // ✅ Auto select pathano
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(
                        initialSelectedCategory: item['name'], // << ekhane pathano holo
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cake,
                        size: 50,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${item['items']} items",
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
