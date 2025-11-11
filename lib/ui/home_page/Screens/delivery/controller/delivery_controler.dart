// lib/core/controller/features/delivery_info_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryInfoController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> deliveryOptions = <Map<String, dynamic>>[].obs;
  final RxList<String> coverageAreas = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDeliveryData();
  }

  void _loadDeliveryData() {
    isLoading.value = true;
    
    // Simulate API call or load static data
    Future.delayed(Duration(seconds: 1), () {
      deliveryOptions.assignAll([
        {
          'icon': Icons.flash_on,
          'title': "এক্সপ্রেস ডেলিভারি",
          'subtitle': "২৪ ঘন্টার মধ্যে",
          'price': "৫০৳",
          'color': Colors.orange,
        },
        {
          'icon': Icons.local_shipping,
          'title': "স্ট্যান্ডার্ড ডেলিভারি", 
          'subtitle': "৪৮-৭২ ঘন্টার মধ্যে",
          'price': "৩০৳",
          'color': Get.theme.primaryColor,
        },
        {
          'icon': Icons.agriculture,
          'title': "ফ্রি ডেলিভারি",
          'subtitle': "৫০০৳+ অর্ডারে",
          'price': "ফ্রি",
          'color': Colors.green,
        },
      ]);

      coverageAreas.assignAll([
        "ঢাকা", "চট্টগ্রাম", "সিলেট", "রাজশাহী", 
        "খুলনা", "বরিশাল", "রংপুর", "ময়মনসিংহ", "সারা বাংলাদেশ"
      ]);

      isLoading.value = false;
    });
  }

  List<Map<String, dynamic>> getDeliveryTerms() {
    return [
      {"text": "ডেলিভারি সময় সকাল ৯টা থেকে রাত ৯টা"},
      {"text": "অর্ডার কনফার্ম হওয়ার ১ ঘন্টার মধ্যে ডেলিভারি শুরু"},
      {"text": "ক্যাশ অন ডেলিভারি Available"},
      {"text": "প্রোডাক্ট সমস্যা হলে ৭ দিনের মধ্যে রিটার্ন"},
      {"text": "ডেলিভারি স্ট্যাটাস লাইভ ট্র্যাক করা যাবে"},
    ];
  }

  void refreshData() {
    _loadDeliveryData();
  }
}