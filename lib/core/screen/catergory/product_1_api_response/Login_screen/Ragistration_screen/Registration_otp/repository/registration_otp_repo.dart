import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/api_response.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';

class UserZxRepository {
  final NetworkClient _networkClient = Get.find<NetworkClient>();

  // ✅ ADDED: Email OTP Verification Method
  Future<NetworkResponse> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    return await _networkClient.postRequest(
      '${Url.baseUrl}/api/verify-email-otp', // আপনার email OTP endpoint
      body: {
        'email': email,
        'otp': otp,
      },
    );
  }

  // ✅ ADDED: Send OTP to Email Method
  Future<NetworkResponse> sendEmailOtp({
    required String email,
  }) async {
    return await _networkClient.postRequest(
      '${Url.baseUrl}/api/send-email-otp', // আপনার send OTP endpoint
      body: {
        'email': email,
      },
    );
  }

  // Phone OTP Verification (existing)
  Future<NetworkResponse> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    return await _networkClient.postRequest(
      '${Url.baseUrl}/api/register/verify',
      body: {
        'phone': phone,
        'otp': otp,
      },
    );
  }

  // User Registration
  Future<NetworkResponse> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await _networkClient.postRequest(
      Url.register,
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'phone': phone,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  // User Login
  Future<NetworkResponse> login({
    required String email,
    required String password,
  }) async {
    return await _networkClient.postRequest(
      Url.login,
      body: {
        'email': email,
        'password': password,
      },
    );
  }

  // Get User Profile
  Future<NetworkResponse> getUserProfile() async {
    return await _networkClient.getRequest(
      Url.userProfile,
    );
  }

  // Update User Profile
  Future<NetworkResponse> updateProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String phone,
    required String email,
    String? image,
  }) async {
    return await _networkClient.putRequest(
      Url.updateProfile,
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'phone': phone,
        'email': email,
        if (image != null) 'image': image,
      },
    );
  }

  // Logout
  Future<NetworkResponse> logout() async {
    return await _networkClient.postRequest(
      Url.logout,
    );
  }

  // Forgot Password
  Future<NetworkResponse> forgotPassword(String email) async {
    return await _networkClient.postRequest(
      Url.forgotPassword,
      body: {'email': email},
    );
  }
}