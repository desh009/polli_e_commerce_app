// lib/core/controller/features/customer_support_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupportController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> contactOptions = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> supportHours = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> commonIssues = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSupportData();
  }

  void _loadSupportData() {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 1), () {
      contactOptions.assignAll([
        {
          'icon': Icons.phone,
          'title': "ফোন করুন",
          'subtitle': "২৪/৭ সাপোর্ট",
          'color': Colors.green,
          'action': _makePhoneCall,
        },
        {
          'icon': Icons.email,
          'title': "ইমেইল করুন",
          'subtitle': "২৪ ঘন্টার মধ্যে রিপ্লাই", 
          'color': Colors.blue,
          'action': _sendEmail,
        },
        {
          'icon': Icons.chat,
          'title': "লাইভ চ্যাট",
          'subtitle': "ইনস্ট্যান্ট সাপোর্ট",
          'color': Colors.orange,
          'action': _openLiveChat,
        },
        {
          'icon': Icons.help_center,
          'title': "এফএকিউ", 
          'subtitle': "সাধারণ প্রশ্ন",
          'color': Colors.purple,
          'action': _openFAQ,
        },
      ]);

      supportHours.assignAll([
        {'day': "সোম-শনি", 'time': "সকাল ৯:০০ - রাত ১০:০০"},
        {'day': "রবিবার", 'time': "সকাল ১০:০০ - রাত ৮:০০"},
        {'day': "জরুরি সাপোর্ট", 'time': "২৪/৭ Available"},
      ]);

      commonIssues.assignAll([
        {
          'title': "অর্ডার সম্পর্কিত সমস্যা", 
          'action': _handleOrderIssue,
        },
        {
          'title': "ডেলিভারি সমস্যা",
          'action': _handleDeliveryIssue, 
        },
        {
          'title': "পেমেন্ট সমস্যা",
          'action': _handlePaymentIssue,
        },
        {
          'title': "প্রোডাক্ট কোয়ালিটি",
          'action': _handleQualityIssue,
        },
        {
          'title': "অ্যাকাউন্ট সমস্যা", 
          'action': _handleAccountIssue,
        },
      ]);

      isLoading.value = false;
    });
  }

  // Contact Methods
  void _makePhoneCall() async {
    final Uri url = Uri.parse('tel:+8801700000000');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar('ত্রুটি', 'ফোন কল করতে পারছি না');
    }
  }

  void _sendEmail() async {
    final Uri url = Uri.parse('mailto:support@polli.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar('ত্রুটি', 'ইমেইল অ্যাপ খুলতে পারছি না');
    }
  }

  void _openLiveChat() {
    Get.snackbar('লাইভ চ্যাট', 'শীঘ্রই আসছে...');
  }

  void _openFAQ() {
    Get.snackbar('এফএকিউ', 'শীঘ্রই আসছে...');
  }

  void _handleOrderIssue() {
    Get.snackbar('অর্ডার সমস্যা', 'সাপোর্ট টিম আপনার সমস্যা Solve করবে');
  }

  void _handleDeliveryIssue() {
    Get.snackbar('ডেলিভারি সমস্যা', 'ডেলিভারি টিম Contact করবে');
  }

  void _handlePaymentIssue() {
    Get.snackbar('পেমেন্ট সমস্যা', 'পেমেন্ট সাপোর্ট Contact করবে');
  }

  void _handleQualityIssue() {
    Get.snackbar('ক্যুয়ালিটি সমস্যা', 'ক্যুয়ালিটি টিম Review করবে');
  }

  void _handleAccountIssue() {
    Get.snackbar('অ্যাকাউন্ট সমস্যা', 'টেকনিক্যাল টিম Solve করবে');
  }

  void refreshData() {
    _loadSupportData();
  }
}