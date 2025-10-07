import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Category1Controller extends GetxController {
    static Category1Controller get instance => Get.find<Category1Controller>();

  var selectedCategory = RxnString();
  var selectedOption = RxnString();
  var currentCategory = 'গুড়'.obs;

  void updateCategory(String category, [String? option]) {
    print("=== CategoryController updateCategory called ===");
    print("New category: $category");
    print("Old category: ${currentCategory.value}");
    
    selectedCategory.value = category;
    selectedOption.value = option;
    currentCategory.value = category;
    
    print("Updated category: ${currentCategory.value}");
    
    update(); // Force update
    refresh(); // Extra force update
  }
    @override
  void onInit() {
    super.onInit();
    // Default category set করুন if needed
    // currentCategory.value = "গুড়"; 
  }
}