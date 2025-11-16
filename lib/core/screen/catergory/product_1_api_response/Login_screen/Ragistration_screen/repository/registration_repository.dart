// registration_repository.dart - COMPLETELY FIXED
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
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
      print('🔄 রেজিস্ট্রেশন শুরু হচ্ছে...');

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

      final response = await networkClient
          .postRequest(Url.register, body: requestBody)
          .timeout(const Duration(seconds: 30));

      print('📊 রেস্পন্স স্ট্যাটাস: ${response.statusCode}');
      print('📊 রেস্পন্স ডাটা টাইপ: ${response.responseData?.runtimeType}');

      if (response.isSuccess) {
        print('✅ API কল সফল হয়েছে');

        // সহজ উপায়: সরাসরি responseData ব্যবহার করুন
        if (response.responseData != null && response.responseData is Map) {
          final responseData = response.responseData as Map<String, dynamic>;
          print('✅ ম্যাপ ডাটা পাওয়া গেছে');
          return RegistrationResponse.fromJson(responseData);
        } 
        // যদি responseData null হয় বা Map না হয়
        else {
          print('⚠️ রেস্পন্স ডাটা ম্যাপ না, তাই ম্যানুয়ালি তৈরি করছি');
          return RegistrationResponse(
            status: 'success',
            message: 'রেজিস্ট্রেশন সফল হয়েছে',
            userEmail: email, user: null, token: '',
          );
        }
      } else {
        print('❌ রেজিস্ট্রেশন ব্যর্থ: ${response.errorMessage}');
        throw Exception(response.errorMessage ?? 'রেজিস্ট্রেশন ব্যর্থ হয়েছে');
      }
    } on TimeoutException catch (e) {
      print('❌ টাইমআউট হয়েছে: $e');
      throw Exception('নেটওয়ার্ক সংযোগ ধীর। আবার চেষ্টা করুন।');
    } catch (e) {
      print('❌ রেজিস্ট্রেশন রিপোজিটরি ত্রুটি: $e');
      rethrow;
    }
  }

  // OTP ভেরিফিকেশন মেথড
  Future<RegistrationResponse> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      print('🔄 OTP ভেরিফাই করা হচ্ছে: $phone');

      final response = await networkClient.postRequest(
        '${Url.baseUrl}/api/verify-otp',
        body: {
          'email': phone,
          'otp': otp,
        },
      ).timeout(const Duration(seconds: 30));

      print('📊 OTP রেস্পন্স স্ট্যাটাস: ${response.statusCode}');

      if (response.isSuccess) {
        print('✅ OTP ভেরিফিকেশন সফল');

        // সহজ উপায়
        if (response.responseData != null && response.responseData is Map) {
          return RegistrationResponse.fromJson(response.responseData as Map<String, dynamic>);
        } else {
          return RegistrationResponse(
            status: 'success', 
            message: 'OTP ভেরিফিকেশন সফল হয়েছে',
            userEmail: phone, user: null, token: '',
          );
        }
      } else {
        print('❌ OTP ভেরিফিকেশন ব্যর্থ: ${response.errorMessage}');
        throw Exception(response.errorMessage ?? 'OTP ভেরিফিকেশন ব্যর্থ হয়েছে');
      }
    } on TimeoutException catch (e) {
      print('❌ OTP টাইমআউট: $e');
      throw Exception('OTP ভেরিফিকেশন টাইমআউট। আবার চেষ্টা করুন।');
    } catch (e) {
      print('❌ OTP ভেরিফিকেশন ত্রুটি: $e');
      rethrow;
    }
  }

  // ইমেইল অ্যাপ্রুভাল স্ট্যাটাস চেক
  Future<bool> checkEmailApprovalStatus({required String email}) async {
    try {
      print('🔍 ইমেইল অ্যাপ্রুভাল চেক: $email');

      final response = await networkClient.getRequest(
        '${Url.baseUrl}/api/check-approval-status?email=$email',
      ).timeout(const Duration(seconds: 15));

      if (response.isSuccess && response.responseData != null && response.responseData is Map) {
        final data = response.responseData as Map<String, dynamic>;
        
        bool isApproved = data['approved'] == true ||
            data['email_verified'] == true ||
            data['status'] == 'approved' ||
            data['is_verified'] == true;

        print('✅ ইমেইল অ্যাপ্রুভাল স্ট্যাটাস: $isApproved');
        return isApproved;
      } else {
        print('❌ অ্যাপ্রুভাল চেক ব্যর্থ');
        return false;
      }
    } on TimeoutException {
      print('❌ অ্যাপ্রুভাল চেক টাইমআউট');
      return false;
    } catch (e) {
      print('❌ অ্যাপ্রুভাল চেক ত্রুটি: $e');
      return false;
    }
  }
}