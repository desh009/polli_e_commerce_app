import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';

class CategoryController extends GetxController {
  var categories = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var error = ''.obs; // ✅ Error variable add করুন
  
  static CategoryController get instance => Get.find<CategoryController>();

  var selectedCategory = RxnString();
  var selectedOption = RxnString();
  var currentCategory = 'গুড়'.obs;

  // ✅ API call করার method
  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      error.value = ''; // ✅ Error reset করুন
      print('🔄 Fetching categories from API...');
      
      final NetworkClient client = Get.find<NetworkClient>();
      final response = await client.getRequest(Url.categoryList);
      
      print('📡 API Response Status: ${response.isSuccess}');
      
      if (response.isSuccess && response.responseData != null) {
        final responseData = response.responseData;
        print('📦 Raw API Response: $responseData');
        
        // ✅ Categories properly extract করুন
        if (responseData != null && responseData.containsKey('categories')) {
          final categoriesList = responseData['categories'] as List;
          categories.value = categoriesList.cast<Map<String, dynamic>>();
          print('✅ Categories loaded: ${categories.length}');
          
          // ✅ প্রথম category টি default হিসেবে set করুন
          if (categories.isNotEmpty) {
            final firstTitle = categories.first['title'];
            currentCategory.value = (firstTitle is String && firstTitle.isNotEmpty) ? firstTitle : 'গুড়';
            print('🏷️ Default category set to: ${currentCategory.value}');
          }
        } else {
          error.value = '"categories" key not found in response';
          print('❌ "categories" key not found in response or responseData is null');
        }
      } else {
        error.value = response.errorMessage ?? 'API Error occurred';
        print('❌ API Error: ${response.errorMessage}');
      }
    } catch (e) {
      error.value = 'Exception: $e';
      print('💥 Exception in fetchCategories: $e');
    } finally {
      isLoading(false);
    }
  }

  void updateCategory(String category, [String? option]) {
    print("=== CategoryController updateCategory called ===");
    print("New category: $category");
    print("Old category: ${currentCategory.value}");
    
    selectedCategory.value = category;
    selectedOption.value = option;
    currentCategory.value = category;
    
    print("Updated category: ${currentCategory.value}");
    
    update(); // ✅ শুধু update() ব্যবহার করুন, refresh() নয়
  }

  @override
  void onInit() {
    super.onInit();
    print('🎯 CategoryController initialized');
    
    // ✅ App start হতেই categories load করুন
    fetchCategories();
  }

  // ✅ Optional: Manual refresh method
  void refreshCategories() {
    fetchCategories();
  }
}