// lib/core/screen/catergory/product_1_api_response/Login_screen/repository/logout_repository.dart
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';

class LogoutRepository {
  final NetworkClient networkClient;

  LogoutRepository({required this.networkClient});

  // lib/core/screen/catergory/product_1_api_response/Login_screen/repository/logout_repository.dart
  Future<bool> performUserLogout() async {
    try {
      print('🔐 Calling logout API...');

      final response = await networkClient.postRequest(Url.logout);

      print('📊 Response Status: ${response.statusCode}');

      // ✅ SUCCESS cases: 200, 201 OR token already expired (401)
      if (response.isSuccess || response.statusCode == 401) {
        print('✅ Logout successful - Token invalidated or already expired');
        return true;
      } else {
        print('❌ Logout failed: ${response.errorMessage}');
        return false;
      }
    } catch (e) {
      print('❌ Logout repository exception: $e');
      return false;
    }
  }
}
