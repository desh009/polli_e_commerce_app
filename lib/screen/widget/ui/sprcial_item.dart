import 'package:flutter/material.dart';
import 'package:polli_e_commerce_app/core/screen/constuctor/constructor.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/view/drawer_view.dart' hide CategoryScreen;

class SpecialItemScreen extends StatefulWidget {
  const SpecialItemScreen({super.key});

  @override
  State<SpecialItemScreen> createState() => _SpecialItemScreenState();
}

class _SpecialItemScreenState extends State<SpecialItemScreen> {
  String? selectedCategory;
  String? selectedOption;

  final List<Map<String, dynamic>> specialItems = const [
    {"name": "খোলিসা মধু", "items": 5},
    {"name": "কুমড়া বোড়ি", "items": 8},
    {"name": "ঘি", "items": 6},
    {"name": "চালের গুড়া", "items": 4},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Special Items"),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // এক সারিতে 2 টা আইটেম
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: specialItems.length,
          itemBuilder: (context, index) {
            final item = specialItems[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(
                      initialSelectedCategory: "Special Item",
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
                    const Icon(Icons.spa, size: 50, color: AppColors.primary),
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
            );
          },
        ),
      ),
    );
  }
}
