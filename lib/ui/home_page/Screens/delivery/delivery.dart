// lib/core/screen/features/delivery_info_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class DeliveryInfoScreen extends StatelessWidget {
  const DeliveryInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ডেলিভারি তথ্য"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(),
            SizedBox(height: 30),
            
            // Delivery Options
            _buildSectionTitle("ডেলিভারি অপশনসমূহ"),
            _buildDeliveryOption(
              icon: Icons.flash_on,
              title: "এক্সপ্রেস ডেলিভারি",
              subtitle: "২৪ ঘন্টার মধ্যে",
              price: "৫০৳",
              color: Colors.orange,
            ),
            _buildDeliveryOption(
              icon: Icons.local_shipping,
              title: "স্ট্যান্ডার্ড ডেলিভারি",
              subtitle: "৪৮-৭২ ঘন্টার মধ্যে", 
              price: "৩০৳",
              color: AppColors.primary,
            ),
            _buildDeliveryOption(
              icon: Icons.agriculture,
              title: "ফ্রি ডেলিভারি",
              subtitle: "৫০০৳+ অর্ডারে",
              price: "ফ্রি",
              color: Colors.green,
            ),
            
            SizedBox(height: 30),
            
            // Coverage Areas
            _buildSectionTitle("ডেলিভারি এরিয়া"),
            _buildCoverageArea(),
            
            SizedBox(height: 30),
            
            // Terms & Conditions
            _buildSectionTitle("শর্তাবলী"),
            _buildTermsConditions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.local_shipping, size: 60, color: Colors.white),
          SizedBox(height: 10),
          Text(
            "দ্রুত ও নির্ভরযোগ্য ডেলিভারি",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "আমরা সারা বাংলাদেশে দ্রুত ডেলিভারি提供服务",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
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

  Widget _buildDeliveryOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String price,
    required Color color,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            price,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoverageArea() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "আমরা নিম্নলিখিত এলাকাগুলোতে ডেলিভারি提供服务:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildAreaChip("ঢাকা"),
                _buildAreaChip("চট্টগ্রাম"),
                _buildAreaChip("সিলেট"),
                _buildAreaChip("রাজশাহী"),
                _buildAreaChip("খুলনা"),
                _buildAreaChip("বরিশাল"),
                _buildAreaChip("রংপুর"),
                _buildAreaChip("ময়মনসিংহ"),
                _buildAreaChip("সারা বাংলাদেশ"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaChip(String area) {
    return Chip(
      label: Text(area),
      backgroundColor: AppColors.primaryLight.withOpacity(0.3),
    );
  }

  Widget _buildTermsConditions() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTermItem("ডেলিভারি সময় সকাল ৯টা থেকে রাত ৯টা"),
            _buildTermItem("অর্ডার কনফার্ম হওয়ার ১ ঘন্টার মধ্যে ডেলিভারি শুরু"),
            _buildTermItem("ক্যাশ অন ডেলিভারি Available"),
            _buildTermItem("প্রোডাক্ট সমস্যা হলে ৭ দিনের মধ্যে রিটার্ন"),
            _buildTermItem("ডেলিভারি স্ট্যাটাস লাইভ ট্র্যাক করা যাবে"),
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 16),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}