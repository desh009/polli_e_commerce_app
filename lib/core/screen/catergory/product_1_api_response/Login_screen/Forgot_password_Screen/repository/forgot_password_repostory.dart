// lib/core/repository/auth/forgot_password_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:polli_e_commerce_app/core/network/url/url.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Forgot_password_Screen/forgot_password_response/forgot_password_response.dart';


class ForgotPasswordRepository {
  Future<ForgotPasswordResponse> forgotPassword(String email) async {
    try {
      final request = ForgotPasswordRequest(email: email);
      
      final response = await http.post(
        Uri.parse(Url.forgotPassword), // ✅ URL class ব্যবহার
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return ForgotPasswordResponse.fromJson(responseData);
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? errorData['msg'] ?? 'Invalid request');
      } else if (response.statusCode == 404) {
        throw Exception('User not found with this email');
      } else if (response.statusCode == 422) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Validation error');
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Something went wrong. Status code: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  // Demo method for testing
  Future<ForgotPasswordResponse> demoForgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 2));
    
    return ForgotPasswordResponse(
      success: true,
      message: 'Password reset link sent successfully.',
    );
  }
}