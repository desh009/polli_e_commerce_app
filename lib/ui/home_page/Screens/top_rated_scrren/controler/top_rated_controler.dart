// lib/core/controller/features/top_rated_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopRatedController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> topProducts = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> customerReviews = <Map<String, dynamic>>[].obs;
  final RxDouble overallRating = 4.8.obs;
  final RxInt totalReviews = 1000.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTopRatedData();
  }

  void _loadTopRatedData() {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 1), () {
      topProducts.assignAll([
        {
          'name': 'খাঁটি মধু',
          'rating': 4.9,
          'reviews': 234,
          'price': '৪৫০৳',
          'image': 'assets/images/honey.png',
        },
        {
          'name': 'খাঁটি গুড়',
          'rating': 4.8, 
          'reviews': 189,
          'price': '২০০৳',
          'image': 'assets/images/gur.jpg',
        },
        {
          'name': 'সরিষার তেল',
          'rating': 4.7,
          'reviews': 156,
          'price': '৩২০৳',
          'image': 'assets/images/tel.jpeg',
        },
        {
          'name': 'হলুদ গুঁড়া',
          'rating': 4.6,
          'reviews': 142, 
          'price': '১৮০৳',
          'image': 'assets/images/mosla.png',
        },
      ]);

      customerReviews.assignAll([
        {
          'name': 'রহিমা আক্তার',
          'comment': 'খাঁটি মধু, খুবই ভালো Quality!',
          'rating': 5,
          'date': '২ দিন আগে',
        },
        {
          'name': 'করিম উদ্দিন',
          'comment': 'দ্রুত ডেলিভারি, প্রোডাক্ট Fresh',
          'rating': 4,
          'date': '১ সপ্তাহ আগে',
        },
        {
          'name': 'আয়েশা বেগম', 
          'comment': 'সেরা সার্ভিস, Highly Recommended!',
          'rating': 5,
          'date': '২ সপ্তাহ আগে',
        },
      ]);

      isLoading.value = false;
    });
  }

  List<String> getWhyTopRated() {
    return [
      "১০০% অথেন্টিক প্রোডাক্ট",
      "দ্রুত ও নির্ভরযোগ্য ডেলিভারি", 
      "সেরা কাস্টমার সার্ভিস",
      "কম্পিটিটিভ প্রাইস", 
      "ফ্রেশ ও কোয়ালিটি গ্যারান্টি",
    ];
  }

  Widget buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  void refreshData() {
    _loadTopRatedData();
  }
}