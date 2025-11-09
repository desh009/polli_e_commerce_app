// lib/core/screen/catergory/product_1_api_response/Login_screen/Registration_screen/repository/registration_repository.dart
import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/registration_response/registration_response.dart';

class RegistrationRepository {
  final NetworkClient networkClient;

  // ✅ FIXED: Correct constructor
  RegistrationRepository(NetworkClient find, {required this.networkClient});

  Future<RegistrationResponse> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      print('🔄 Registering user...');
      print('🌐 API URL: ${Url.register}');
      print('📧 Email: $email');
      print('👤 Name: $firstName $lastName');

      final Map<String, dynamic> requestBody = {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'phone': phone,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'device_name': 'mobile', // Add if required by your API
      };

      print('📦 Request Body: $requestBody');

      final response = await networkClient.postRequest(
        Url.register,
        body: requestBody,
      );

      print('📊 Registration response status: ${response.statusCode}');
      print('📄 Response Data: ${response.responseData}');

      if (response.isSuccess) {
        print('✅ Registration successful');
        final registrationResponse = RegistrationResponse.fromJson(
          response.responseData!,
        );
        return registrationResponse;
      } else {
        print('❌ Registration failed: ${response.errorMessage}');
        throw Exception(response.errorMessage ?? 'Registration failed');
      }
    } catch (e) {
      print('❌ Registration repository error: $e');
      rethrow;
    }
  }

  // ✅ FIXED: Email approval status check
  Future<bool> checkEmailApprovalStatus({required String email}) async {
    try {
      print('🔍 Checking email approval status for: $email');
      
      final response = await networkClient.getRequest(
        '${Url.baseUrl}/api/check-approval-status?email=$email',
      );

      if (response.isSuccess) {
        final data = response.responseData;
        print('📧 Approval check response: $data');
        
        // Adjust according to your API response structure
        bool isApproved = data?['approved'] == true || 
                         data?['email_verified'] == true ||
                         data?['status'] == 'approved' ||
                         data?['is_verified'] == true;
        
        print('✅ Email approval status: $isApproved');
        return isApproved;
      } else {
        print('❌ Approval check failed: ${response.errorMessage}');
        return false;
      }
    } catch (e) {
      print('❌ Check approval status error: $e');
      return false;
    }
  }

  // ✅ FIXED: Resend verification code
  Future<bool> resendVerificationCode({required String email}) async {
    try {
      print('📧 Resending verification code to: $email');

      final response = await networkClient.postRequest(
        '${Url.baseUrl}/api/resend-verification',
        body: {'email': email},
      );

      if (response.isSuccess) {
        print('✅ Verification code resent successfully');
        return true;
      } else {
        print('❌ Resend code failed: ${response.errorMessage}');
        return false;
      }
    } catch (e) {
      print('❌ Resend verification code error: $e');
      return false;
    }
  }

  // ✅ NEW: Verify email with token (if your API has this)
  Future<bool> verifyEmail({required String token}) async {
    try {
      print('🔐 Verifying email with token...');

      final response = await networkClient.postRequest(
        '${Url.baseUrl}/api/email/verify',
        body: {'token': token},
      );

      if (response.isSuccess) {
        print('✅ Email verified successfully');
        return true;
      } else {
        print('❌ Email verification failed: ${response.errorMessage}');
        return false;
      }
    } catch (e) {
      print('❌ Email verification error: $e');
      return false;
    }
  }
}