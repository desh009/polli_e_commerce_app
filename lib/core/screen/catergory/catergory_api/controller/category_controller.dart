import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/repository/category_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/response/category_response.dart';

class Category1Controller extends GetxController {
  final Category1Repository repository;

  Category1Controller(this.repository);

  var categories = <Category>[].obs;
  var isLoading = false.obs;
  var error = "".obs;

  // Dynamic maps
  final Map<String, int> categoryNameToId = {};
  final Map<String, int> subCategoryNameToId = {};

  // Reactive selected category
  var currentCategory = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      error.value = "";
      final data = await repository.getCategories();
      categories.assignAll(data);

      // Build dynamic maps
      _buildCategoryMaps(data);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ NEW METHOD: loadCategories - fetchCategories এর alias
  Future<void> loadCategories() async {
    await fetchCategories();
  }

  void _buildCategoryMaps(List<Category> categoriesList) {
    categoryNameToId.clear();
    subCategoryNameToId.clear();

    for (var category in categoriesList) {
      if (category.parentId == null) {
        categoryNameToId[category.title] = category.id;
      } else {
        subCategoryNameToId[category.title] = category.id;
      }
    }
  }

  /// Helper: Get category ID by name (checks main + sub categories)
  int? getCategoryIdByName(String name) {
    if (categoryNameToId.containsKey(name)) return categoryNameToId[name];
    if (subCategoryNameToId.containsKey(name)) return subCategoryNameToId[name];
    return null;
  }

  /// Update current selected category
  void updateCategory(String categoryName, [String? option]) {
    currentCategory.value = categoryName;
    // Optionally handle other selection logic
  }

  /// ✅ Additional helper methods
  List<Category> get mainCategories {
    return categories.where((category) => category.parentId == null).toList();
  }

  List<Category> get subCategories {
    return categories.where((category) => category.parentId != null).toList();
  }

  List<Category> getSubCategoriesByParentId(int parentId) {
    return categories.where((category) => category.parentId == parentId).toList();
  }

  Category? getCategoryById(int id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}