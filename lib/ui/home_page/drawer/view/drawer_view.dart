import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/controller/category_controller.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/response/category_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/view/category_screen.dart';
import 'package:polli_e_commerce_app/moduls/Log_out/binder/log_out_binder.dart';
import 'package:polli_e_commerce_app/moduls/Log_out/view/logout_view.dart';
import 'package:polli_e_commerce_app/moduls/my_order/bindings/my_order_bindings.dart';
import 'package:polli_e_commerce_app/moduls/my_order/view/My_order_view.dart';
import 'package:polli_e_commerce_app/moduls/settings/settings_binder/setings_binder.dart';
import 'package:polli_e_commerce_app/moduls/settings/view/settings_view.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/Screens/favourite_pages/binder/favourite_page_binder.dart';
import 'package:polli_e_commerce_app/ui/home_page/Screens/favourite_pages/favourite_pages.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/2nd_category_model/2nd_category_model.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/Screens/profile_screen/binder/profile_update_screen_binder.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/Screens/profile_screen/controller/profile_update_screen_controller.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/Screens/profile_screen/view/profile_update_screen_view.dart';
import 'package:polli_e_commerce_app/ui/home_page/view/home_page.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/controller/2nd_category_controller.dart';




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
  final ProfileXController profileController = Get.find<ProfileXController>();

  final Map<int, bool> _categoryExpansionState = {};
  int? _currentlyExpandedCategoryId;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    print('🔄 CustomDrawer initialized');
    // Print current state for debugging
    profileController.printCurrentState();
  }

  // ✅ Navigate to Profile Screen
  void _navigateToProfileScreen() {
    Navigator.pop(context);
    Get.to(() => AdvancedProfileScreen(), binding: ProfileBinding());
  }

  // ✅ Profile Image Picker Methods
  Future<void> _pickProfileImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

   

      if (image != null) {
        await profileController.updateProfileImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'ছবি আপডেট করতে সমস্যা হয়েছে: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _pickProfileImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        await profileController.updateProfileImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'ক্যামেরা ব্যবহার করতে সমস্যা হয়েছে: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showProfileImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'প্রোফাইল ছবি নির্বাচন করুন',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('গ্যালারি থেকে নির্বাচন করুন'),
                onTap: () {
                  Navigator.pop(context);
                  _pickProfileImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('ক্যামেরা দিয়ে ছবি তুলুন'),
                onTap: () {
                  Navigator.pop(context);
                  _pickProfileImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ✅ FIXED: Complete Obx implementation
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

  // ✅ COMPLETELY FIXED: User Header with proper reactive updates
  Widget _buildUserHeader() {
    return Obx(() {
      print('🔄 UserHeader Obx rebuilding - Name: ${profileController.userName}, Email: ${profileController.userEmail}');
      
      return GestureDetector(
        onTap: _navigateToProfileScreen,
        child: UserAccountsDrawerHeader(
          accountName: Text(
            profileController.userName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          accountEmail: Text(
            profileController.userEmail,
            style: TextStyle(fontSize: 12),
          ),
          currentAccountPicture: Stack(
            children: [
              // ✅ Profile Image with Obx
              Obx(() => CircleAvatar(
                backgroundColor: Colors.white,
                radius: 36,
                child: _buildProfileImage(),
              )),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showProfileImagePickerOptions,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            ),
          ),
        ),
      );
    });
  }

  // ✅ FIXED: Profile Image with proper Obx
  Widget _buildProfileImage() {
    return Obx(() {
      if (profileController.hasProfileImage.value &&
          profileController.profileImagePath.value.isNotEmpty) {
        return ClipOval(
          child: Image.file(
            File(profileController.profileImagePath.value),
            fit: BoxFit.cover,
            width: 70,
            height: 70,
            errorBuilder: (context, error, stackTrace) {
              print('❌ Error loading profile image: $error');
              return _buildDefaultProfileIcon();
            },
          ),
        );
      } else {
        return _buildDefaultProfileIcon();
      }
    });
  }

  Widget _buildDefaultProfileIcon() {
    return Icon(Icons.person, color: AppColors.primary, size: 36);
  }

  // ... Rest of your methods (categories, menu items etc.) remain the same
  Widget _buildCategoriesSection() {
    return ExpansionTile(
      leading: Icon(Icons.category, color: AppColors.primary),
      title: const Text("ক্যাটেগরি", style: TextStyle(fontWeight: FontWeight.bold)),
      initiallyExpanded: true,
      children: [
        Obx(() {
          if (categoryController.isLoading.value) return _buildLoadingWidget();
          if (categoryController.error.value.isNotEmpty) return _buildErrorWidget();
          if (categoryController.categories.isEmpty) return _buildEmptyWidget();

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
      title: Text(category.title, style: const TextStyle(fontWeight: FontWeight.w500)),
      initiallyExpanded: isExpanded,
      onExpansionChanged: (expanded) {
        setState(() {
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
      children: [_buildSubcategoriesContent(categoryId, category.title)],
    );
  }

  Widget _buildSubcategoriesContent(int categoryId, String categoryTitle) {
    return Obx(() {
      final isCurrentCategory = category2Controller.selectedCategoryId == categoryId;
      if (!isCurrentCategory) return const SizedBox.shrink();

      if (category2Controller.isChildrenLoading.value) return _buildChildrenLoadingWidget();
      if (category2Controller.childrenError.value.isNotEmpty) return _buildChildrenErrorWidget(categoryId, categoryTitle);
      if (!category2Controller.hasChildren || category2Controller.activeChildren.isEmpty) return _buildNoChildrenWidget();

      return Column(
        children: [
          ...category2Controller.activeChildren.map((subCategory) => _buildSubcategoryItem(subCategory)).toList(),
          const Divider(height: 20),
          _buildSeeAllOption(categoryTitle),
        ],
      );
    });
  }

  Widget _buildSubcategoryItem(Category2 subCategory) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 56, right: 16),
      leading: _buildSubcategoryIcon(subCategory),
      title: Text(subCategory.title, style: const TextStyle(fontSize: 14)),
      dense: true,
      visualDensity: VisualDensity.compact,
      onTap: () {
        _navigateToCategoryScreen(subCategory.title, null);
        category2Controller.selectChildCategory(subCategory);
      },
    );
  }

  Widget _buildCategoryIcon(Category category) {
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
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
      onTap: () {
        _navigateToCategoryScreen(categoryTitle, null);
        if (category2Controller.parentCategory != null) {
          category2Controller.selectParentCategory();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }


  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          Text("ত্রুটি: ${categoryController.error.value}", style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => categoryController.loadCategories(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text("আবার চেষ্টা করুন"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text("কোনো ক্যাটেগরি পাওয়া যায়নি", style: TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildChildrenLoadingWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(height: 8),
            Text('সাব-ক্যাটেগরি লোড হচ্ছে...', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
          Text("ত্রুটি: ${category2Controller.childrenError.value}", style: const TextStyle(color: Colors.orange, fontSize: 12)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _loadCategoryDetails(categoryId, categoryTitle),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
            child: const Text("আবার চেষ্টা করুন", style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoChildrenWidget() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text("কোনো সাব-ক্যাটেগরি নেই", style: TextStyle(color: Colors.grey, fontSize: 12)),
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
            Get.to(() => FavouritePage(), binding: FavouriteBinder());
          },
        ),
        ListTile(
          leading: Icon(Icons.person, color: AppColors.primary),
          title: const Text("প্রোফাইল"),
          onTap: _navigateToProfileScreen,
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
      title: const Text("লগআউট", style: TextStyle(color: Colors.red)),
      onTap: () {
        Navigator.pop(context);
        Get.to(() => LogoutView(), binding: LogoutBinding());
      },
    );
  }

  void _loadCategoryDetails(int categoryId, String categoryTitle) {
    category2Controller.loadCategoryDetails(categoryId);
  }

  void _clearCategoryData() {
    category2Controller.clearData();
  }

  void _navigateToCategoryScreen(String categoryName, String? option) {
    Navigator.pop(context);
    Get.to(
      () => CategoryScreen(
        key: UniqueKey(),
        initialSelectedCategory: categoryName,
        initialSelectedOption: option,
      ),
    );
  }
}