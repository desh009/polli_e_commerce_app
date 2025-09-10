import 'package:flutter/material.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/view/category_screen.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/view/drawer_view.dart' hide CategoryScreen;

class MoslaScreen extends StatefulWidget {
  const MoslaScreen({super.key});

  @override
  State<MoslaScreen> createState() => _MoslaScreenState();
}
// there is no more vais in mumbai..every body knows that honesty is the best policy,there is no body who knows honesty is not a good policy
class _MoslaScreenState extends State<MoslaScreen> {
  String? selectedCategory;

  final List<Map<String, dynamic>> moslaItems = const [
    {"name": "মরিচ", "items": 10},
    {"name": "হলুদ", "items": 8},
    {"name": "জিরা", "items": 12},
    {"name": "ধনিয়া", "items": 6},
    {"name": "গরম মসলা", "items": 5},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("মসলা Categories"),
        centerTitle: true,
        backgroundColor: AppColors.primaryLight,
      ),
      drawer: CustomDrawer(
        onSelectCategory: (String category, String? option) {
          setState(() {
            selectedCategory = category;
          });
          Navigator.pop(context); // drawer বন্ধ
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: moslaItems.map((item) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 36) / 2,
              child: InkWell(
                onTap: () {
                  // ✅ শুধু item name পাঠানো হচ্ছে
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(
                        initialSelectedCategory: item['name'], 
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
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
