// registration_repository.dart
import 'dart:async';

import 'package:polli_e_commerce_app/core/network/api_client.dart';
import 'package:polli_e_commerce_app/core/network/api_response.dart';
import 'package:polli_e_commerce_app/core/network/url/url.dart';
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/Ragistration_screen/registration_response/registration_response.dart';

class RegistrationRepository {
  final NetworkClient networkClient;

  RegistrationRepository({required this.networkClient});

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

      final Map<String, dynamic> requestBody = {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'phone': phone,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'device_name': 'mobile',
      };

      print('📦 Request Body: $requestBody');

      final response = await networkClient
          .postRequest(Url.register, body: requestBody)
          .timeout(Duration(seconds: 30));

      print('📊 Registration response status: ${response.statusCode}');

      if (response.isSuccess && response.responseData != null) {
        print('✅ Registration API call successful');
        final registrationResponse = RegistrationResponse.fromJson(
          response.responseData!,
        );

        return registrationResponse;
      } else {
        print('❌ Registration failed: ${response.errorMessage}');
        throw Exception(response.errorMessage ?? 'Registration failed');
      }
   } on TimeoutException catch (e) {
    print('❌ Registration API timeout: $e');
    throw Exception('রেজিস্ট্রেশন রিকোয়েস্ট টাইমআউট হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।');
  } catch (e) {
    print('❌ Registration repository error: $e');
    rethrow;
  }
}
  // ✅ OTP Verification Method
  Future<NetworkResponse> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      print('🔄 Verifying OTP for: $phone');

      final response = await networkClient.postRequest(
        '${Url.baseUrl}/api/verify-otp',
        body: {
          'email': phone, // ✅ Using email as identifier
          'otp': otp,
        },
      );

      if (response.isSuccess) {
        print('✅ OTP verification API success');
      } else {
        print('❌ OTP verification failed: ${response.errorMessage}');
      }

      return response;
    } catch (e) {
      print('❌ OTP verification error: $e');
      rethrow;
    }
  }

  // ✅ RESEND OTP METHOD - ADD THIS
  Future<NetworkResponse> resendOtp({
    required String phone, // This parameter can be email
  }) async {
    try {
      print('🔄 Resending OTP to: $phone');

      final response = await networkClient.postRequest(
        '${Url.baseUrl}/api/resend-otp', // ✅ Your resend OTP endpoint
        body: {
          'email': phone, // ✅ Using email as identifier
        },
      );

      if (response.isSuccess) {
        print('✅ Resend OTP API success');
      } else {
        print('❌ Resend OTP failed: ${response.errorMessage}');
      }

      return response;
    } catch (e) {
      print('❌ Resend OTP error: $e');
      rethrow;
    }
  }

  // ✅ Email approval status check
  Future<bool> checkEmailApprovalStatus({required String email}) async {
    try {
      print('🔍 Checking email approval status for: $email');

      final response = await networkClient.getRequest(
        '${Url.baseUrl}/api/check-approval-status?email=$email',
      );

      if (response.isSuccess) {
        final data = response.responseData;
        print('📧 Approval check response: $data');

        bool isApproved =
            data?['approved'] == true ||
            data?['email_verified'] == true ||
            data?['status'] == 'approved' ||
            data?['is_verified'] == true ||
            data?['verified'] == true;

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

  // Resend verification code
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

  // Verify email with token
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
