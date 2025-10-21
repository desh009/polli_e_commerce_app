// category2_controller.dart
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/2nd_category_model/2nd_category_model.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/repository/2nd_category_repository.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/response/2nd_category_response.dart';

class Category2Controller extends GetxController {
  final Category2Repository repository;

  Category2Controller(this.repository);

  // Reactive states
  var categoryDetails = Rxn<Category2Response>();
  var childrenCategories = <Category2>[].obs;
  var selectedCategory = Rxn<Category2>();

  // Loading & error
  var isLoading = false.obs;
  var isChildrenLoading = false.obs;
  var errorMessage = ''.obs;
  var childrenError = ''.obs;

  // Dynamic maps
  final Map<String, int> categoryNameToId = {};
  final Map<String, int> subCategoryNameToId = {};

  @override
  void onInit() {
    super.onInit();
    print('🔄 Category2Controller initialized');
  }

  Future<void> loadCategoryDetails(int categoryId) async {
    try {
      isLoading(true);
      errorMessage('');
      childrenCategories.clear();
      selectedCategory.value = null;
      
      print('📥 Loading category details for ID: $categoryId');

      final details = await repository.getCategoryDetails(categoryId);

      categoryDetails(details);
      childrenCategories.assignAll(details.children);
      selectedCategory(details.category);

      _buildCategoryMaps();
      
      print('✅ Loaded category: ${details.category.title} with ${details.children.length} children');
    } catch (e) {
      errorMessage(e.toString());
      print('❌ Error loading category details: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadCategoryChildren(int categoryId) async {
    try {
      isChildrenLoading(true);
      childrenError('');
      print('📥 Loading children for category ID: $categoryId');

      final children = await repository.getCategoryChildren(categoryId);
      childrenCategories.assignAll(children);
      
      // Update mapping
      _buildCategoryMaps();
      
      print('✅ Loaded ${children.length} children categories');
    } catch (e) {
      childrenError(e.toString());
      print('❌ Error loading category children: $e');
    } finally {
      isChildrenLoading(false);
    }
  }

  void _buildCategoryMaps() {
    categoryNameToId.clear();
    subCategoryNameToId.clear();

    if (categoryDetails.value != null) {
      // Parent category
      categoryNameToId[categoryDetails.value!.category.title] = 
          categoryDetails.value!.category.id;

      // Children categories
      for (var child in childrenCategories) {
        subCategoryNameToId[child.title] = child.id;
      }
    }
    
    print('🗺️ Built category maps: $categoryNameToId');
    print('🗺️ Built sub-category maps: $subCategoryNameToId');
  }

  void selectParentCategory() {
    if (categoryDetails.value != null) {
      selectedCategory(categoryDetails.value!.category);
      print('🎯 Selected parent category: ${selectedCategory.value?.title}');
    }
  }

  void selectChildCategory(Category2 child) {
    selectedCategory(child);
    print('🎯 Selected child category: ${child.title}');
  }

  void clearData() {
    categoryDetails.value = null;
    childrenCategories.clear();
    selectedCategory.value = null;
    errorMessage('');
    childrenError('');
    categoryNameToId.clear();
    subCategoryNameToId.clear();
    print('🧹 Cleared all category data');
  }

  // ✅ Improved Helpers
  bool get hasCategory => categoryDetails.value != null;
  bool get hasChildren => childrenCategories.isNotEmpty;
  int? get selectedCategoryId => selectedCategory.value?.id;
  
  // ✅ FIXED: Null safety for selected category name
  String get selectedCategoryName => selectedCategory.value?.title ?? '';
  
  Category2? get parentCategory => categoryDetails.value?.category;
  List<Category2> get allChildren => childrenCategories;

  // ✅ FIXED: activeChildren with isActive getter
  List<Category2> get activeChildren => childrenCategories.where((c) => c.isActive).toList();

  // ✅ FIXED: childrenWithImages with hasImage getter
  List<Category2> get childrenWithImages => childrenCategories.where((c) => c.hasImage).toList();
  
  bool get anyLoading => isLoading.value || isChildrenLoading.value;
  bool get hasError => errorMessage.isNotEmpty || childrenError.isNotEmpty;
  
  // ✅ New helper for UI
  bool get canShowChildren => hasCategory && hasChildren && !anyLoading;

  // ✅ Get category ID by name
  int? getCategoryIdByName(String name) {
    // First check in parent categories
    if (categoryNameToId.containsKey(name)) {
      return categoryNameToId[name];
    }
    
    // Then check in sub categories
    if (subCategoryNameToId.containsKey(name)) {
      return subCategoryNameToId[name];
    }
    
    // If not found in mapping, check in current children
    for (var child in childrenCategories) {
      if (child.title == name) {
        return child.id;
      }
    }
    
    // Check in current parent category
    if (categoryDetails.value != null && categoryDetails.value!.category.title == name) {
      return categoryDetails.value!.category.id;
    }
    
    return null;
  }

  // ✅ Check if category exists in mapping
  bool hasCategoryInMapping(String categoryName) {
    return categoryNameToId.containsKey(categoryName) || 
           subCategoryNameToId.containsKey(categoryName);
  }

  // ✅ Get all category names (for debugging)
  List<String> getAllCategoryNames() {
    List<String> names = [];
    names.addAll(categoryNameToId.keys);
    names.addAll(subCategoryNameToId.keys);
    return names;
  }

  // ✅ Get category by ID
  Category2? getCategoryById(int id) {
    // Check parent category
    if (categoryDetails.value != null && categoryDetails.value!.category.id == id) {
      return categoryDetails.value!.category;
    }
    
    // Check children categories
    for (var child in childrenCategories) {
      if (child.id == id) {
        return child;
      }
    }
    
    return null;
  }
}