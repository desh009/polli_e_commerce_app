import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileXController extends GetxController {
  // User profile data - Make sure these are properly observable
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;
  final RxString profileImagePath = ''.obs;
  final RxBool hasProfileImage = false.obs;
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ✅ ADD: Separate observable variables for name and email
  final RxString _userName = 'Palli Swad User'.obs;
  final RxString _userEmail = 'customer@polliswad.com'.obs;

  @override
  void onInit() {
    super.onInit();
    print('🔄 ProfileXController initialized');
    _loadInitialProfileData();
  }

  void _loadInitialProfileData() {
    print('📥 Loading initial profile data');
    
    userProfile.value = {
      'full_name': 'Palli Swad User',
      'email': 'customer@polliswad.com',
      'phone': '+8801XXXXXXXXX',
      'address': 'Dhaka, Bangladesh',
      'date_of_birth': '01/01/1990',
    };
    
    // ✅ UPDATE separate observables
    _userName.value = userProfile['full_name'] ?? 'Palli Swad User';
    _userEmail.value = userProfile['email'] ?? 'customer@polliswad.com';
    
    _loadProfileImageFromStorage();
  }

  void _loadProfileImageFromStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imageFile = File('${directory.path}/profile_image.jpg');
      
      if (await imageFile.exists()) {
        profileImagePath.value = imageFile.path;
        hasProfileImage.value = true;
        print('📸 Profile image loaded from storage: ${imageFile.path}');
        update();
      } else {
        print('📸 No profile image found in storage');
      }
    } catch (e) {
      print('❌ Error loading profile image from storage: $e');
    }
  }

  // ✅ FIXED: Update Profile Method with proper observable updates
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? address,
    String? dateOfBirth,
    File? image,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔄 PROFILE UPDATE STARTED: $name, $email, $phone');

      // Update profile image if provided
      if (image != null) {
        await updateProfileImage(image);
      }

      // ✅ FIXED: Update user profile data
      userProfile.value = {
        'full_name': name,
        'email': email,
        'phone': phone,
        'address': address ?? userProfile['address'],
        'date_of_birth': dateOfBirth ?? userProfile['date_of_birth'],
      };

      // ✅ CRITICAL FIX: Update separate observable variables
      _userName.value = name;
      _userEmail.value = email;

      print('✅ UserProfile updated: ${userProfile.value}');
      print('✅ Observable values updated - Name: $_userName, Email: $_userEmail');

      await Future.delayed(const Duration(seconds: 1));

      // ✅ IMPORTANT: Force update all listeners
      update();
      
      print('✅ update() method called - notifying all listeners');

      Get.snackbar(
        'সফল!',
        'প্রোফাইল আপডেট করা হয়েছে',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      errorMessage.value = 'Profile update failed: $e';
      print('❌ Error updating profile: $e');
      
      Get.snackbar(
        'ত্রুটি',
        'প্রোফাইল আপডেট করতে সমস্যা হয়েছে: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    try {
      isLoading.value = true;

      print('🔄 Updating profile image...');

      final directory = await getApplicationDocumentsDirectory();
      final savedImage = File('${directory.path}/profile_image.jpg');
      
      await imageFile.copy(savedImage.path);
      
      profileImagePath.value = savedImage.path;
      hasProfileImage.value = true;

      await Future.delayed(const Duration(milliseconds: 500));

      print('✅ Profile image updated: ${savedImage.path}');
      
      update();

      Get.snackbar(
        'সফল!',
        'প্রোফাইল ছবি আপডেট করা হয়েছে',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      print('❌ Error updating profile image: $e');
      
      Get.snackbar(
        'ত্রুটি',
        'ছবি আপডেট করতে সমস্যা হয়েছে: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ FIXED: Getter methods that return observable values
  String get userName => _userName.value;
  String get userEmail => _userEmail.value;

  // ✅ For debugging
  void printCurrentState() {
    print('''
📊 ProfileXController Current State:
- UserName: $_userName
- UserEmail: $_userEmail  
- UserProfile: $userProfile
- HasImage: $hasProfileImage
- ImagePath: $profileImagePath
''');
  }
}