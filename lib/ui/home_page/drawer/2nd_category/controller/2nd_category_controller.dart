import 'package:get/get.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/2nd_category_response/2nd_category_response.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/repository/2nd_category_repository.dart';

class SubCategoryController extends GetxController {
  final SubCategoryRepository repository;

  SubCategoryController(this.repository);

  var isLoading = false.obs;
  var error = ''.obs;
  var categories = <SubCategoryResponse>[].obs;

  Future<void> fetchCategories(int parentId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await repository.getCategoryById(parentId);
      categories.clear();
      categories.add(data); // ✅ data is SubCategoryResponse
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
