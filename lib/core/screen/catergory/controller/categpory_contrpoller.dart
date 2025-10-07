import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart'; // আপনার NetworkClient import

class Category1Controller extends GetxController {
  var categories = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  
  static Category1Controller get instance => Get.find<Category1Controller>();

  var selectedCategory = RxnString();
  var selectedOption = RxnString();
  var currentCategory = 'গুড়'.obs;

  // ✅ API call করার method যোগ করুন
  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      print('🔄 Fetching categories from API...');
      
      final NetworkClient client = Get.find<NetworkClient>(); // NetworkClient instance নিন
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
          print('❌ "categories" key not found in response or responseData is null');
        }
      } else {
        print('❌ API Error: ${response.errorMessage}');
      }
    } catch (e) {
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
    
    update();
    refresh();
  }

  @override
  void onInit() {
    super.onInit();
    print('🎯 Category1Controller initialized');
    
    // ✅ App start হতেই categories load করুন
    fetchCategories();
  }
}