// lib/core/repository/epic_auth_repository.dart
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/auth_response/auth_response.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/login_response/login_response.dart';

class EpicAuthRepository {
  final NetworkClient _networkClient;

  EpicAuthRepository({required NetworkClient networkClient}) 
      : _networkClient = networkClient;

  // 🔐 Login Method
  Future<EpicAuthResponse> performUserLogin({
    required String emailAddress,
    required String password,
  }) async {
    final response = await _networkClient.postRequest(
      Url.login,
      body: {
        'email': emailAddress,
        'password': password,
      },
    );

    if (response.isSuccess && response.responseData != null) {
      return EpicAuthResponse.fromJson(response.responseData!); // ✅ Null check
    } else {
      throw Exception(response.errorMessage ?? 'Login failed');
    }
  }

  // 👤 Get User Profile
  Future<EpicUserData> fetchUserProfile() async {
    final response = await _networkClient.getRequest(Url.userProfile);

    if (response.isSuccess) {
      return EpicUserData.fromJson(response.responseData?['user'] ?? {});
    } else {
      throw Exception(response.errorMessage ?? 'Failed to load profile');
    }
  }

  // 🚪 Logout Method
  Future<void> performUserLogout() async {
    final response = await _networkClient.postRequest(Url.logout);

    if (!response.isSuccess) {
      throw Exception(response.errorMessage ?? 'Logout failed');
    }
  }

  // 📝 User Registration
  Future<EpicAuthResponse> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await _networkClient.postRequest(
      Url.register,
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': password,
      },
    );

    if (response.isSuccess) {
      return EpicAuthResponse.fromJson(response.responseData?['user'] ?? {});
    } else {
      throw Exception(response.errorMessage ?? 'Registration failed');
    }
  }
}