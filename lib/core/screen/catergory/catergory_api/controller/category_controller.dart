import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/repository/category_repository.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/catergory_api/response/category_response.dart';

class Category1Controller extends GetxController {
  final CategoryRepository repository;

  Category1Controller(this.repository);

  var categories = <Category>[].obs;
  var isLoading = false.obs;
  var error = "".obs;

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
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}