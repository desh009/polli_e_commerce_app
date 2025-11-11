// lib/core/screen/features/customer_support_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("সাপোর্ট"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Support Header
            _buildSupportHeader(),
            SizedBox(height: 30),
            
            // Contact Options
            _buildSectionTitle("যোগাযোগ করুন"),
            _buildContactOption(
              icon: Icons.phone,
              title: "ফোন করুন",
              subtitle: "২৪/৭ সাপোর্ট",
              onTap: () => _makePhoneCall("+8801700000000"),
              color: Colors.green,
            ),
            _buildContactOption(
              icon: Icons.email,
              title: "ইমেইল করুন",
              subtitle: "২৪ ঘন্টার মধ্যে রিপ্লাই",
              onTap: () => _sendEmail("support@polli.com"),
              color: Colors.blue,
            ),
            _buildContactOption(
              icon: Icons.chat,
              title: "লাইভ চ্যাট",
              subtitle: "ইনস্ট্যান্ট সাপোর্ট",
              onTap: _openLiveChat,
              color: Colors.orange,
            ),
            _buildContactOption(
              icon: Icons.help_center,
              title: "এফএকিউ",
              subtitle: "সাধারণ প্রশ্ন",
              onTap: _openFAQ,
              color: Colors.purple,
            ),
            
            SizedBox(height: 30),
            
            // Support Hours
            _buildSectionTitle("সাপোর্ট সময়"),
            _buildSupportHours(),
            
            SizedBox(height: 30),
            
            // Common Issues
            _buildSectionTitle("সাধারণ সমস্যা"),
            _buildCommonIssues(),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.support_agent, size: 60, color: Colors.white),
          SizedBox(height: 10),
          Text(
            "আমরা এখানে আছি আপনাকে সাহায্য করার জন্য",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "যেকোনো সমস্যায় আমাদের সাথে যোগাযোগ করুন",
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

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
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
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSupportHours() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTimeSlot("সোম-শনি", "সকাল ৯:০০ - রাত ১০:০০"),
            _buildTimeSlot("রবিবার", "সকাল ১০:০০ - রাত ৮:০০"),
            _buildTimeSlot("জরুরি সাপোর্ট", "২৪/৭ Available"),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String day, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(time, style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildCommonIssues() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildIssueItem("অর্ডার সম্পর্কিত সমস্যা", _handleOrderIssue),
            _buildIssueItem("ডেলিভারি সমস্যা", _handleDeliveryIssue),
            _buildIssueItem("পেমেন্ট সমস্যা", _handlePaymentIssue),
            _buildIssueItem("প্রোডাক্ট কোয়ালিটি", _handleQualityIssue),
            _buildIssueItem("অ্যাকাউন্ট সমস্যা", _handleAccountIssue),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueItem(String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(Icons.help_outline, color: Colors.blue),
      title: Text(text),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Contact Methods
  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar('ত্রুটি', 'ফোন কল করতে পারছি না');
    }
  }

  void _sendEmail(String email) async {
    final Uri url = Uri.parse('mailto:$email');
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
}