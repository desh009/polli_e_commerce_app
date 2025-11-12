import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileXController extends GetxController {
  var userProfile = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  var isProfileUpdated = false.obs;
  final selectedImage = Rxn<File>();

  final ImagePicker _picker = ImagePicker();
  final String _profileDataKey = 'user_profile_data';
  final String _profileUpdatedKey = 'profile_updated_status';

  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();

      final profileDataString = prefs.getString(_profileDataKey);
      if (profileDataString != null) {
        userProfile.value = _parseProfileData(profileDataString);
      } else {
        userProfile.value = {
          'name': '',
          'email': '',
          'phone': '',
          'address': '',
          'date_of_birth': '',
          'has_profile_image': false,
        };
      }

      isProfileUpdated.value = prefs.getBool(_profileUpdatedKey) ?? false;

      final imagePath = userProfile.value['profile_image_local'];
      if (imagePath != null && imagePath is String) {
        final file = File(imagePath);
        if (await file.exists()) {
          selectedImage.value = file;
        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _parseProfileData(String dataString) {
    try {
      if (dataString.startsWith('{') && dataString.endsWith('}')) {
        String content = dataString.substring(1, dataString.length - 1);
        List<String> pairs = content.split(',');

        Map<String, dynamic> result = {};
        for (String pair in pairs) {
          List<String> keyValue = pair.split(':');
          if (keyValue.length == 2) {
            String key = keyValue[0].trim().replaceAll("'", "");
            String value = keyValue[1].trim().replaceAll("'", "");

            if (value == 'true')
              result[key] = true;
            else if (value == 'false')
              result[key] = false;
            else
              result[key] = value;
          }
        }
        return result;
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<void> _saveProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileDataKey, userProfile.value.toString());
      await prefs.setBool(_profileUpdatedKey, isProfileUpdated.value);
    } catch (e) {
      print('❌ Error saving profile data: $e');
    }
  }

  // ✅ NEW METHOD: updateProfileWithAllFields যোগ করুন
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    String dateOfBirth = '',
    File? image,
  }) async {
    try {
      isLoading.value = true;

      // Update local profile data
      userProfile.value = {
        ...userProfile.value,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'date_of_birth': dateOfBirth,
        'updated_at': DateTime.now().toString(),
      };

      // Handle image if provided
      if (image != null) {
        selectedImage.value = image;
        userProfile.value = {
          ...userProfile.value,
          'profile_image_local': image.path,
          'has_profile_image': true,
        };
      }

      isProfileUpdated.value = true;
      await _saveProfileData();

      isLoading.value = false;

      Get.snackbar(
        'সফল!',
        'প্রোফাইল আপডেট করা হয়েছে',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      isLoading.value = false;
      Get.snackbar('ত্রুটি', 'আপডেট করতে সমস্যা হয়েছে: $e');
    }
  }

  // Getters
  String get userDisplayName =>
      userProfile.value['name']?.toString() ?? 'আপনার নাম';
  String get userEmail => userProfile.value['email']?.toString() ?? 'ইমেইল নেই';
  String get userPhone =>
      userProfile.value['phone']?.toString() ?? 'ফোন নম্বর নেই';
  String get userAddress =>
      userProfile.value['address']?.toString() ?? 'ঠিকানা নেই';
  String get userDateOfBirth =>
      userProfile.value['date_of_birth']?.toString() ?? 'জন্ম তারিখ নেই';
  bool get hasProfileImage => userProfile.value['has_profile_image'] == true;
  String? get profileImagePath =>
      userProfile.value['profile_image_local']?.toString();
  bool get isProfileCompleted =>
      userProfile.value['name'] != null &&
      userProfile.value['name']!.toString().isNotEmpty;

  String get lastUpdateTime {
    final updatedAt = userProfile.value['updated_at'];
    if (updatedAt != null) {
      try {
        final dateTime = DateTime.parse(updatedAt.toString());
        return 'সর্বশেষ আপডেট: ${dateTime.day}/${dateTime.month}/${dateTime.year}';
      } catch (e) {
        return 'সর্বশেষ আপডেট: অজানা';
      }
    }
    return 'কখনো আপডেট করা হয়নি';
  }
}