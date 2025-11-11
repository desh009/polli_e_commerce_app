// lib/core/screen/features/top_rated_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class TopRatedScreen extends StatelessWidget {
  const TopRatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("টপ রেটেড প্রোডাক্ট"),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Rated Header
            _buildTopRatedHeader(),
            SizedBox(height: 30),
            
            // Top Products
            _buildSectionTitle("সর্বোচ্চ রেটেড প্রোডাক্ট"),
            _buildTopProductList(),
            
            SizedBox(height: 30),
            
            // Customer Reviews
            _buildSectionTitle("কাস্টমার রিভিউ"),
            _buildCustomerReviews(),
            
            SizedBox(height: 30),
            
            // Why We're Top Rated
            _buildSectionTitle("কেন আমরা টপ রেটেড?"),
            _buildWhyTopRated(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRatedHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.star, size: 60, color: Colors.white),
          SizedBox(height: 10),
          Text(
            "⭐ ৪.৮/৫ রেটিং",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "১০০০+ সন্তুষ্ট কাস্টমার",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTopProductList() {
    final topProducts = [
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
    ];

    return Column(
      children: topProducts.map((product) {
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.primaryLight,
              child: Icon(Icons.shopping_bag, color: AppColors.primary),
            ),
            title: Text(
              product['name'] as String,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' ${product['rating']}'),
                    SizedBox(width: 10),
                    Text('(${product['reviews']} রিভিউ)'),
                  ],
                ),
                Text('দাম: ${product['price']}'),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomerReviews() {
    final reviews = [
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
    ];

    return Column(
      children: reviews.map((review) {
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        (review['name'] as String).substring(0, 1),
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['name'] as String,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            review['date'] as String,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    _buildRatingStars(review['rating'] as int),
                  ],
                ),
                SizedBox(height: 8),
                Text(review['comment'] as String),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRatingStars(int rating) {
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

  Widget _buildWhyTopRated() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildReasonItem("১০০% অথেন্টিক প্রোডাক্ট"),
            _buildReasonItem("দ্রুত ও নির্ভরযোগ্য ডেলিভারি"),
            _buildReasonItem("সেরা কাস্টমার সার্ভিস"),
            _buildReasonItem("কম্পিটিটিভ প্রাইস"),
            _buildReasonItem("ফ্রেশ ও কোয়ালিটি গ্যারান্টি"),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified, color: Colors.green, size: 16),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}