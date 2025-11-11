import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polli_e_commerce_app/sub_modules/app_colors/app_colors.dart';
import 'package:polli_e_commerce_app/ui/home_page/drawer/Screens/profile_screen/controller/profile_update_screen_controller.dart';

class AdvancedProfileScreen extends StatefulWidget {
  const AdvancedProfileScreen({super.key});

  @override
  State<AdvancedProfileScreen> createState() => _AdvancedProfileScreenState();
}

class _AdvancedProfileScreenState extends State<AdvancedProfileScreen> {
  final ProfileXController profileController = Get.find<ProfileXController>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    // Load existing profile data
    final profile = profileController.userProfile.value;

    fullNameController.text = profile['full_name']?.toString() ?? '';
    phoneController.text = profile['phone']?.toString() ?? '';
    dateOfBirthController.text = profile['date_of_birth']?.toString() ?? '';
    addressController.text = profile['address']?.toString() ?? '';
    emailController.text = profile['email']?.toString() ?? '';

    // Load profile image if exists
    if (profileController.hasProfileImage &&
        profileController.profileImagePath != null) {
      _selectedImage = File(profileController.profileImagePath!);
    }
  }

  // Image Picker Methods
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });

        Get.snackbar(
          'সফল!',
          'প্রোফাইল ছবি নির্বাচন করা হয়েছে',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'ছবি নির্বাচন করতে সমস্যা হয়েছে: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });

        Get.snackbar(
          'সফল!',
          'ছবি তোলা হয়েছে',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'ক্যামেরা ব্যবহার করতে সমস্যা হয়েছে: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'প্রোফাইল ছবি নির্বাচন করুন',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.primary),
                title: Text('গ্যালারি থেকে নির্বাচন করুন'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text('ক্যামেরা দিয়ে ছবি তুলুন'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Date Picker
  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        dateOfBirthController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // ✅ NEW METHOD: _updateProfile তৈরি করা হয়েছে
  Future<void> _updateProfile() async {
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final dateOfBirth = dateOfBirthController.text.trim();
    final address = addressController.text.trim();
    final email = emailController.text.trim();

    // Validation
    if (fullName.isEmpty) {
      Get.snackbar(
        'ত্রুটি',
        'পুরো নাম পূরণ করুন',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (phone.isEmpty) {
      Get.snackbar(
        'ত্রুটি',
        'ফোন নম্বর পূরণ করুন',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await profileController.updateProfileWithAllFields(
        name: fullName,
        email: email,
        phone: phone,
        address: address,
        dateOfBirth: dateOfBirth,
        image: _selectedImage,
      );
      
      Get.snackbar(
        'সফল!',
        'প্রোফাইল আপডেট করা হয়েছে',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'প্রোফাইল আপডেট করতে সমস্যা হয়েছে: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('প্রোফাইল আপডেট'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateProfile, // ✅ FIXED: _updateProfile method কল হচ্ছে
            tooltip: 'সেভ করুন',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture Section
            _buildProfilePictureSection(),
            SizedBox(height: 30),

            // Personal Information
            _buildPersonalInfoSection(),
            SizedBox(height: 20),

            // Contact Information
            _buildContactInfoSection(),
            SizedBox(height: 30),

            // Update Button
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _showImagePickerOptions,
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: _selectedImage != null
                    ? ClipOval(
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      )
                    : profileController.hasProfileImage &&
                            profileController.profileImagePath != null
                        ? ClipOval(
                            child: Image.file(
                              File(profileController.profileImagePath!),
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundColor: AppColors.primaryLight,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.primary,
                            ),
                          ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          'ছবি পরিবর্তন করতে ট্যাপ করুন',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _pickImageFromGallery,
              icon: Icon(Icons.photo_library, size: 16),
              label: Text('গ্যালারি'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
            TextButton.icon(
              onPressed: _pickImageFromCamera,
              icon: Icon(Icons.camera_alt, size: 16),
              label: Text('ক্যামেরা'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ব্যক্তিগত তথ্য',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 16),
            _buildFormField(
              controller: fullNameController,
              label: 'পুরো নাম *',
              hintText: 'আপনার পুরো নাম লিখুন',
              icon: Icons.person,
            ),
            SizedBox(height: 16),
            _buildDateField(
              controller: dateOfBirthController,
              label: 'জন্ম তারিখ',
              hintText: 'জন্ম তারিখ নির্বাচন করুন',
              icon: Icons.calendar_today,
              onTap: _selectDateOfBirth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'যোগাযোগের তথ্য',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 16),
            _buildFormField(
              controller: emailController,
              label: 'ইমেইল',
              hintText: 'আপনার ইমেইল ঠিকানা',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            _buildFormField(
              controller: phoneController,
              label: 'ফোন নম্বর *',
              hintText: 'আপনার ফোন নম্বর',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            _buildFormField(
              controller: addressController,
              label: 'ঠিকানা',
              hintText: 'আপনার সম্পূর্ণ ঠিকানা',
              icon: Icons.location_on,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: IgnorePointer(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: Icon(icon, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _updateProfile, // ✅ FIXED: _updateProfile method কল হচ্ছে
        child: Text(
          'প্রোফাইল আপডেট করুন',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}