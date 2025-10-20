import 'package:flutter/material.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/view/drawer_view.dart';

class MoslaScreen extends StatelessWidget {
  const MoslaScreen({super.key});

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

      // ✅ Drawer (Reuse করার জন্য পরে আলাদা CustomDrawer বানানো যাবে)
      drawer:CustomDrawer(onSelectCategory: (String category, String? option) {  },),
      // ✅ Responsive Body
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: moslaItems.map((item) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 36) / 2, // 2 per row
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${item['name']} clicked")),
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
