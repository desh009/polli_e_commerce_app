import 'package:get/get.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/2nd_category_response/2nd_category_response.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/2nd_category/repository/2nd_category_repository.dart';

class CategoryController extends GetxController {
  final Category2Repository repository;

  CategoryController(this.repository);

  var isLoading = false.obs;
  var error = ''.obs;
  var categories = <Category2Response>[].obs; // ✅ Correct type

  Future<void> fetchCategories(int parentId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await repository.getCategoryById(parentId);
      categories.clear();
      categories.add(data); // data is Category2Response
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
