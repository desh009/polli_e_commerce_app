import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';
import 'package:polli_e_commerce_app/ui/home_page/Slider_api/Slider_api_response/slider_api_response.dart';

class SliderRepository {
  final NetworkClient networkClient;

  SliderRepository({required this.networkClient});

  Future<List<SliderItem>> fetchSliders() async {
    try {
      final response = await networkClient.getRequest(Url.slider);
      
      print('🎯 Slider API Status: ${response.isSuccess}');
      
      if (response.isSuccess && response.responseData != null) {
        // Multiple possible keys check
        final List data = response.responseData?['slider'] ?? 
                         response.responseData?['sliders'] ?? 
                         response.responseData?['data'] ?? [];
        
        print('📊 Slider Items Found: ${data.length}');
        
        return data.map((e) => SliderItem.fromJson(e)).toList();
      } else {
        print('❌ Slider API Error: ${response.errorMessage}');
        return [];
      }
    } catch (e) {
      print('💥 Repository Error: $e');
      return [];
    }
  }
}