import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/response/category_response.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/2nd_category_response/2nd_category_response.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/repository/2nd_category_repository.dart';

class Category2Controller extends GetxController {
  final Category2Repository _categoryDetailsRepository;

  Category2Controller(this._categoryDetailsRepository);

  // Dynamic maps
  final Map<String, int> categoryNameToId = {};
  final Map<String, int> subCategoryNameToId = {};

  // Observable states
  var categoryDetails = Rxn<Category2Response>();
  var childrenCategories = <Category>[].obs;
  var selectedCategory = Rxn<Category>();

  // Loading states
  var isLoading = false.obs;
  var isChildrenLoading = false.obs;

  // Error states
  var errorMessage = ''.obs;
  var childrenError = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// ক্যাটেগরি ডিটেইলস লোড করা (ক্যাটেগরি + চিলড্রেন)
  Future<void> loadCategoryDetails(int categoryId) async {
    try {
      isLoading(true);
      errorMessage('');
      
      // 🔹 এখানে আগের getCategoryByyId এর জায়গায় getCategoryDetails ব্যবহার করলাম
      final details = await _categoryDetailsRepository.getCategoryDetails(categoryId);
      categoryDetails(details);
      childrenCategories.assignAll(details.children);
      selectedCategory(details.category);

      // Dynamic map update
      _buildCategoryMaps();
    } catch (e) {
      errorMessage(e.toString());
      print('❌ Error loading category details: $e');
    } finally {
      isLoading(false);
    }
  }

  /// শুধু চিলড্রেন ক্যাটেগরি লোড করা
  Future<void> loadCategoryChildren(int categoryId) async {
    try {
      isChildrenLoading(true);
      childrenError('');
      final children = await _categoryDetailsRepository.getCategoryChildren(categoryId);
      childrenCategories.assignAll(children);
    } catch (e) {
      childrenError(e.toString());
      print('❌ Error loading category children: $e');
    } finally {
      isChildrenLoading(false);
    }
  }

  /// Dynamic map builder
  void _buildCategoryMaps() {
    categoryNameToId.clear();
    subCategoryNameToId.clear();

    if (categoryDetails.value != null) {
      // parent category
      categoryNameToId[categoryDetails.value!.category.title] =
          categoryDetails.value!.category.id;

      // children
      for (var child in childrenCategories) {
        subCategoryNameToId[child.title] = child.id;
      }
    }
  }

  /// স্পেসিফিক চাইল্ড সিলেক্ট করা
  void selectChildCategory(Category category) {
    selectedCategory(category);
  }

  /// প্যারেন্ট ক্যাটেগরি সিলেক্ট করা
  void selectParentCategory() {
    if (categoryDetails.value != null) {
      selectedCategory(categoryDetails.value!.category);
    }
  }

  /// সব ডাটা ক্লিয়ার করা
  void clearData() {
    categoryDetails.value = null;
    childrenCategories.clear();
    selectedCategory.value = null;
    errorMessage('');
    childrenError('');
  }

  /// ক্যাটেগরি আছে কিনা চেক করা
  bool get hasCategory => categoryDetails.value != null;

  /// চিলড্রেন আছে কিনা চেক করা
  bool get hasChildren => childrenCategories.isNotEmpty;

  /// বর্তমান সিলেক্টেড ক্যাটেগরি ID
  int? get selectedCategoryId => selectedCategory.value?.id;

  /// বর্তমান সিলেক্টেড ক্যাটেগরি নাম
  String get selectedCategoryName => selectedCategory.value?.title ?? '';

  /// প্যারেন্ট ক্যাটেগরি
  Category? get parentCategory => categoryDetails.value?.category;

  /// সব চিলড্রেন ক্যাটেগরি
  List<Category> get allChildren => childrenCategories;

  /// শুধু active চিলড্রেন ক্যাটেগরি
  List<Category> get activeChildren {
    return childrenCategories.where((category) => category.status == 1).toList();
  }

  /// ইমেজ সহ চিলড্রেন ক্যাটেগরি
  List<Category> get childrenWithImages {
    return childrenCategories.where((category) => category.image != null).toList();
  }

  /// কোনো লোডিং চলছে কিনা
  bool get anyLoading => isLoading.value || isChildrenLoading.value;

  /// কোনো এরর আছে কিনা
  bool get hasError => errorMessage.isNotEmpty || childrenError.isNotEmpty;
}
