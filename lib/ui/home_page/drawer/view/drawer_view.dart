import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/controller/category_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/response/category_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/view/category_screen.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/2nd_category_model/2nd_category_model.dart';
import 'package:polli_e_commerce_app/ui/home_page/view/home_page.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/controller/2nd_category_controller.dart';

// Import your other modules
import 'package:polli_e_commerce_app/moduls/my_order/view/my_order_view.dart';
import 'package:polli_e_commerce_app/moduls/my_order/bindings/my_order_bindings.dart';
import 'package:polli_e_commerce_app/moduls/my_wishlist/view/my_wish_list_view.dart';
import 'package:polli_e_commerce_app/moduls/my_wishlist/binder/my_wish_list_binder.dart';
import 'package:polli_e_commerce_app/moduls/profile/view/profile_view.dart';
import 'package:polli_e_commerce_app/moduls/profile/binder/profile_binder.dart';
import 'package:polli_e_commerce_app/moduls/settings/view/settings_view.dart';
import 'package:polli_e_commerce_app/moduls/settings/settings_binder/setings_binder.dart';
import 'package:polli_e_commerce_app/moduls/Log_out/view/logout_view.dart';
import 'package:polli_e_commerce_app/moduls/Log_out/binder/log_out_binder.dart';

class CustomDrawer extends StatefulWidget {
  final String? initialSelectedCategory;
  final String? initialSelectedOption;
  final Function(String category, String? option) onSelectCategory;

  const CustomDrawer({
    super.key,
    required this.onSelectCategory,
    this.initialSelectedCategory,
    this.initialSelectedOption,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final Category1Controller categoryController = Get.find<Category1Controller>();
  final Category2Controller category2Controller = Get.find<Category2Controller>();

  final Map<int, bool> _categoryExpansionState = {};
  int? _currentlyExpandedCategoryId;

  @override
  void initState() {
    super.initState();
    print('🔄 CustomDrawer initialized with Category2Controller');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildUserHeader(),
          _buildCategoriesSection(),
          const Divider(),
          _buildMenuItems(),
          const Divider(),
          _buildLogoutItem(),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return UserAccountsDrawerHeader(
      accountName: const Text("Palli Swad"),
      accountEmail: const Text("customer@polliswad.com"),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.store, color: AppColors.primary, size: 36),
      ),
      decoration: BoxDecoration(color: AppColors.primary),
    );
  }

  Widget _buildCategoriesSection() {
    return ExpansionTile(
      leading: Icon(Icons.category, color: AppColors.primary),
      title: const Text(
        "ক্যাটেগরি",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: true,
      children: [
        Obx(() {
          if (categoryController.isLoading.value) {
            return _buildLoadingWidget();
          }

          if (categoryController.error.isNotEmpty) {
            return _buildErrorWidget();
          }

          if (categoryController.categories.isEmpty) {
            return _buildEmptyWidget();
          }

          return Column(
            children: categoryController.mainCategories.map((category) {
              return _buildCategoryWithSubcategories(category);
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryWithSubcategories(Category category) {
    final categoryId = category.id;
    final isExpanded = _categoryExpansionState[categoryId] ?? false;

    return ExpansionTile(
      key: Key('category_$categoryId'),
      leading: _buildCategoryIcon(category),
      title: Text(
        category.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      initiallyExpanded: isExpanded,
      onExpansionChanged: (expanded) {
        setState(() {
          // Collapse previously expanded category
          if (_currentlyExpandedCategoryId != null && _currentlyExpandedCategoryId != categoryId) {
            _categoryExpansionState[_currentlyExpandedCategoryId!] = false;
          }
          
          _categoryExpansionState[categoryId] = expanded;
          _currentlyExpandedCategoryId = expanded ? categoryId : null;
        });
        
        if (expanded) {
          _loadCategoryDetails(categoryId, category.title);
        } else {
          _clearCategoryData();
        }
      },
      children: [
        _buildSubcategoriesContent(categoryId, category.title),
      ],
    );
  }

  Widget _buildSubcategoriesContent(int categoryId, String categoryTitle) {
    return Obx(() {
      // Check if this is the currently expanded category
      final isCurrentCategory = category2Controller.selectedCategoryId == categoryId;
      
      if (!isCurrentCategory) {
        return const SizedBox.shrink();
      }

      // Loading state
      if (category2Controller.isChildrenLoading.value) {
        return _buildChildrenLoadingWidget();
      }

      // Error state
      if (category2Controller.childrenError.isNotEmpty) {
        return _buildChildrenErrorWidget(categoryId, categoryTitle);
      }

      // No subcategories
      if (!category2Controller.hasChildren) {
        return _buildNoChildrenWidget();
      }

      return Column(
        children: [
          // Subcategories list
          ...category2Controller.activeChildren.map((subCategory) => 
            _buildSubcategoryItem(subCategory)
          ).toList(),

          const Divider(height: 20),

          // "See All" option
          _buildSeeAllOption(categoryTitle),
        ],
      );
    });
  }

  Widget _buildSubcategoryItem(Category2 subCategory) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 56, right: 16),
      leading: _buildSubcategoryIcon(subCategory),
      title: Text(
        subCategory.title,
        style: const TextStyle(fontSize: 14),
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
      onTap: () {
        print("🎯 Selected subcategory: ${subCategory.title} (ID: ${subCategory.id})");
        _navigateToCategoryScreen(subCategory.title, null);
        
        // Update category2 controller selection
        category2Controller.selectChildCategory(subCategory);
      },
    );
  }

  // Widget _buildSubcategoryItem(Category2 subCategory) {
  //   if (subCategory.hasImage) {
  //     return CircleAvatar(
  //       backgroundImage: NetworkImage(subCategory.imageUrl),
  //       radius: 12,
  //       backgroundColor: Colors.grey[200],
  //       onBackgroundImageError: (exception, stackTrace) {
  //         print('❌ Image load error for ${subCategory.title}: $exception');
  //       },
  //     );
  //   }
    
  //   return Icon(Icons.category_outlined, size: 16, color: AppColors.primary);
  // }

Widget _buildCategoryIcon(Category category) {
  // ✅ FIXED: Null safety for category image
  if (category.image != null && category.image!.isNotEmpty) {
    String imageUrl = category.image!;
    if (!imageUrl.startsWith('http')) {
      imageUrl = 'https://inventory.growtech.com.bd/$imageUrl';
    }
    
    return CircleAvatar(
      backgroundImage: NetworkImage(imageUrl),
      radius: 16,
      onBackgroundImageError: (exception, stackTrace) {
        print('❌ Image load error for ${category.title}: $exception');
      },
    );
  }
  
  return Icon(Icons.category, color: AppColors.primary, size: 24);
}

Widget _buildSubcategoryIcon(Category2 subCategory) {
  // ✅ FIXED: Use hasImage getter which handles null safety
  if (subCategory.hasImage) {
    return CircleAvatar(
      backgroundImage: NetworkImage(subCategory.imageUrl),
      radius: 12,
      backgroundColor: Colors.grey[200],
      onBackgroundImageError: (exception, stackTrace) {
        print('❌ Image load error for ${subCategory.title}: $exception');
      },
    );
  }
  
  return Icon(Icons.category_outlined, size: 16, color: AppColors.primary);
}
  Widget _buildSeeAllOption(String categoryTitle) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 56, right: 16),
      leading: Icon(Icons.list_alt, size: 16, color: AppColors.primary),
      title: Text(
        "সব $categoryTitle দেখুন",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
      onTap: () {
        print("📦 See all selected: $categoryTitle");
        _navigateToCategoryScreen(categoryTitle, null);
        
        // Select parent category
        if (category2Controller.parentCategory != null) {
          category2Controller.selectParentCategory();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('ক্যাটেগরি লোড হচ্ছে...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          Text(
            "ত্রুটি: ${categoryController.error.value}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => categoryController.loadCategories(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text("আবার চেষ্টা করুন"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "কোনো ক্যাটেগরি পাওয়া যায়নি",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildChildrenLoadingWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(height: 8),
            Text(
              'সাব-ক্যাটেগরি লোড হচ্ছে...',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenErrorWidget(int categoryId, String categoryTitle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.orange, size: 24),
          const SizedBox(height: 4),
          Text(
            "ত্রুটি: ${category2Controller.childrenError.value}",
            style: const TextStyle(color: Colors.orange, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _loadCategoryDetails(categoryId, categoryTitle),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            child: const Text(
              "আবার চেষ্টা করুন",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoChildrenWidget() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "কোনো সাব-ক্যাটেগরি নেই",
        style: TextStyle(color: Colors.grey, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.home, color: AppColors.primary),
          title: const Text("হোম"),
          onTap: () {
            Navigator.pop(context);
            Get.offAll(() => HomePage());
          },
        ),
        ListTile(
          leading: Icon(Icons.shopping_cart, color: AppColors.primary),
          title: const Text("আমার অর্ডার"),
          onTap: () {
            Navigator.pop(context);
            Get.to(() => MyOrderView(), binding: MyOrderBinding());
          },
        ),
        ListTile(
          leading: Icon(Icons.favorite, color: AppColors.primary),
          title: const Text("পছন্দের তালিকা"),
          onTap: () {
            Navigator.pop(context);
            Get.to(() => WishlistView(), binding: WishlistBinding());
          },
        ),
        ListTile(
          leading: Icon(Icons.person, color: AppColors.primary),
          title: const Text("প্রোফাইল"),
          onTap: () {
            Navigator.pop(context);
            Get.to(() => ProfileView(), binding: ProfileBinding());
          },
        ),
        ListTile(
          leading: Icon(Icons.settings, color: AppColors.primary),
          title: const Text("সেটিংস"),
          onTap: () {
            Navigator.pop(context);
            Get.to(() => SettingsView(), binding: SettingsBinding());
          },
        ),
      ],
    );
  }

  Widget _buildLogoutItem() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        "লগআউট",
        style: TextStyle(color: Colors.red),
      ),
      onTap: () {
        Navigator.pop(context);
        Get.to(() => LogoutView(), binding: LogoutBinding());
      },
    );
  }

  void _loadCategoryDetails(int categoryId, String categoryTitle) {
    print('🔄 Loading category details for: $categoryTitle (ID: $categoryId)');
    category2Controller.loadCategoryDetails(categoryId);
  }

  void _clearCategoryData() {
    print('🧹 Clearing category data from drawer');
    category2Controller.clearData();
  }

  void _navigateToCategoryScreen(String categoryName, String? option) {
    print("🎯 Navigating to category: $categoryName, option: $option");
    
    // Close drawer first
    Navigator.pop(context);
    
    // Navigate to category screen
    Get.to(
      () => CategoryScreen(
        key: UniqueKey(),
        initialSelectedCategory: categoryName,
        initialSelectedOption: option,
      ),
    );
  }
}