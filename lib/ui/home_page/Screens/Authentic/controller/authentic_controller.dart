// lib/core/controller/features/authentic_products_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticProductsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> qualityFeatures = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> certifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadAuthenticData();
  }

  void _loadAuthenticData() {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 1), () {
      qualityFeatures.assignAll([
        {
          'icon': Icons.eco,
          'title': "১০০% অরগানিক",
          'description': "কেমিক্যাল মুক্ত ও প্রাকৃতিক",
        },
        {
          'icon': Icons.verified_user,
          'title': "হালাল সার্টিফাইড", 
          'description': "হালাল সার্টিফিকেশন আছে",
        },
        {
          'icon': Icons.local_florist,
          'title': "ফ্রেশ প্রোডাক্ট",
          'description': "তাজা ও সতেজ প্রোডাক্ট",
        },
        {
          'icon': Icons.health_and_safety,
          'title': "স্বাস্থ্যকর",
          'description': "স্বাস্থ্যের জন্য উপকারী",
        },
      ]);

      certifications.assignAll([
        {
          'title': "বিএসটিআই অনুমোদিত",
          'subtitle': "বাংলাদেশ স্ট্যান্ডার্ডস অ্যান্ড টেস্টিং ইনস্টিটিউশন",
        },
        {
          'title': "হালাল সার্টিফিকেট",
          'subtitle': "ইসলামিক ফাউন্ডেশন কর্তৃক Certified",
        },
        {
          'title': "ফুড গ্রেড মেটেরিয়াল", 
          'subtitle': "খাদ্য গ্রেড উপকরণ ব্যবহার",
        },
        {
          'title': "কোয়ালিটি কন্ট্রোল",
          'subtitle': "স্ট্রিক্ট কোয়ালিটি কন্ট্রোল প্রসেস",
        },
      ]);

      isLoading.value = false;
    });
  }

  List<String> getWhyChooseUs() {
    return [
      "স্থানীয় কৃষকদের থেকে সরাসরি সংগ্রহ",
      "কেমিক্যাল ও প্রিজারভেটিভ মুক্ত", 
      "পরিবেশবান্ধব প্যাকেজিং",
      "ফ্রেশনেস গ্যারান্টি",
      "মানুষের স্বাস্থ্যকে প্রাধান্য",
    ];
  }

  void refreshData() {
    _loadAuthenticData();
  }
}