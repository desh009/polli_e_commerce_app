// lib/core/screen/features/authentic_products_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class AuthenticProductsScreen extends StatelessWidget {
  const AuthenticProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("অথেন্টিক প্রোডাক্ট"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Authentic Guarantee Header
            _buildAuthenticHeader(),
            SizedBox(height: 30),
            
            // Quality Features
            _buildSectionTitle("ক্যুয়ালিটি ফিচারস"),
            _buildQualityFeature(
              icon: Icons.eco,
              title: "১০০% অরগানিক",
              description: "কেমিক্যাল মুক্ত ও প্রাকৃতিক",
            ),
            _buildQualityFeature(
              icon: Icons.verified_user,
              title: "হালাল সার্টিফাইড", 
              description: "হালাল সার্টিফিকেশন আছে",
            ),
            _buildQualityFeature(
              icon: Icons.local_florist,
              title: "ফ্রেশ প্রোডাক্ট",
              description: "তাজা ও সতেজ প্রোডাক্ট",
            ),
            _buildQualityFeature(
              icon: Icons.health_and_safety,
              title: "স্বাস্থ্যকর",
              description: "স্বাস্থ্যের জন্য উপকারী",
            ),
            
            SizedBox(height: 30),
            
            // Certification
            _buildSectionTitle("সার্টিফিকেশন"),
            _buildCertificationSection(),
            
            SizedBox(height: 30),
            
            // Why Choose Us
            _buildSectionTitle("কেন আমাদের প্রোডাক্ট নির্বাচন করবেন?"),
            _buildWhyChooseUs(),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.verified, size: 60, color: Colors.white),
          SizedBox(height: 10),
          Text(
            "১০০% অথেন্টিক গ্যারান্টি",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "আমরা শুধুমাত্র ভেরিফাইড ও ক্যুয়ালিটি প্রোডাক্ট提供করি",
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

  Widget _buildQualityFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.green),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildCertificationSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCertificationItem(
              "বিএসটিআই অনুমোদিত",
              "বাংলাদেশ স্ট্যান্ডার্ডস অ্যান্ড টেস্টিং ইনস্টিটিউশন",
            ),
            _buildCertificationItem(
              "হালাল সার্টিফিকেট",
              "ইসলামিক ফাউন্ডেশন কর্তৃক Certified",
            ),
            _buildCertificationItem(
              "ফুড গ্রেড মেটেরিয়াল",
              "খাদ্য গ্রেড উপকরণ ব্যবহার",
            ),
            _buildCertificationItem(
              "কোয়ালিটি কন্ট্রোল",
              "স্ট্রিক্ট কোয়ালিটি কন্ট্রোল প্রসেস",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationItem(String title, String subtitle) {
    return ListTile(
      leading: Icon(Icons.verified, color: Colors.green),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildWhyChooseUs() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildReasonItem("স্থানীয় কৃষকদের থেকে সরাসরি সংগ্রহ"),
            _buildReasonItem("কেমিক্যাল ও প্রিজারভেটিভ মুক্ত"),
            _buildReasonItem("পরিবেশবান্ধব প্যাকেজিং"),
            _buildReasonItem("ফ্রেশনেস গ্যারান্টি"),
            _buildReasonItem("মানুষের স্বাস্থ্যকে প্রাধান্য"),
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
          Icon(Icons.star, color: Colors.amber, size: 16),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}