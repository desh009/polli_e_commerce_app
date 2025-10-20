import 'package:get/get.dart';
import '../repository/slider_api_repository.dart';
import '../Slider_api_response/slider_api_response.dart';

class SliderController extends GetxController {
  final SliderRepository repository;

  SliderController({required this.repository});

  var sliders = <SliderItem>[].obs;
  var isLoading = true.obs;
  var error = ''.obs;
  

  @override
  void onInit() {
    super.onInit();
    fetchSliders();
  }

  Future<void> fetchSliders() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      print('🔄 Fetching sliders...');
      final result = await repository.fetchSliders();
      
      print('✅ Sliders loaded: ${result.length}');
      sliders.assignAll(result);
      
    } catch (e) {
      error.value = 'Slider load করতে সমস্যা: $e';
      sliders.clear();
      print("❌ Slider fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Retry method যোগ করুন (UI তে প্রয়োজন)
  void retryFetchSliders() {
    fetchSliders();
  }
}