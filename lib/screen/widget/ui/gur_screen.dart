import 'package:flutter/material.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/view/category_screen.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/view/drawer_view.dart';

class GurScreen extends StatefulWidget {
  const GurScreen({super.key});

  @override
  State<GurScreen> createState() => _GurScreenState();
}

class _GurScreenState extends State<GurScreen> {
  String? selectedCategory;
  String? selectedOption;

  final List<Map<String, dynamic>> gurItems = const [
    {"name": "বিজ গুড়", "items": 10},
    {"name": "দানাদার গুড়", "items": 8},
    {"name": "নারকেল গুড়", "items": 12},
    {"name": "ঘোলা গুড়", "items": 5},
    {"name": "চকলেট গুড়", "items": 7},
    {"name": "পাতালি গুড়", "items": 3}, // "পাটালি" spelling ঠিক করেছি
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("গুড় Categories"),
        centerTitle: true,
        backgroundColor: AppColors.primaryLight,
      ),
      drawer: CustomDrawer(
        onSelectCategory: (String category, String? option) {
          setState(() {
            selectedCategory = category;
            selectedOption = option;
          });
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          // GridView.count এর বদলে builder ব্যবহার
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: gurItems.length,
          itemBuilder: (context, index) {
            final item = gurItems[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(
                      initialSelectedCategory: "গুড়", // fixed main category
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(
                12,
              ), // InkWell এর ripple effect এর জন্য
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    // একটু shadow যোগ করেছি
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cake, size: 40, color: AppColors.primary),
                    const SizedBox(height: 8),
                    Text(
                      item['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2, // maximum 2 line text
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${item['items']} items",
                      style: const TextStyle(
                        fontSize: 12,
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
