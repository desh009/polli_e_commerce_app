import 'package:flutter/material.dart';
import 'package:polli_e_commerce_app/core/screen/constuctor/constructor.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/view/drawer_view.dart';

class TelScreen extends StatefulWidget {
  const TelScreen({super.key});

  @override
  State<TelScreen> createState() => _TelScreenState();
}

class _TelScreenState extends State<TelScreen> {
  String? selectedCategory;
  String? selectedOption;
  final List<Map<String, dynamic>> telItems = const [
    {"name": "নারকেল তেল", "items": 10},
    {"name": "সরিষার তেল", "items": 8},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("তেল Categories"),
        centerTitle: true,
        backgroundColor: AppColors.primaryLight,
      ),
      drawer: CustomDrawer(
        onSelectCategory: (String category, String? option) {
          setState(() {
            selectedCategory = category;
            selectedOption = option;
          });
          Navigator.pop(context); // drawer বন্ধ
        },
      ),      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: telItems.map((item) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 36) / 2,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(
                        initialSelectedCategory: "তেল",
                        initialSelectedOption: item['name'],
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
                      const Icon(Icons.opacity,
                          size: 50, color: AppColors.primary),
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
