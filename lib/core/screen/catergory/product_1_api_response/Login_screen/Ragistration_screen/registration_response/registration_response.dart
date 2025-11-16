class RegistrationResponse {
  final String status;
  final String message;
  final dynamic user;
  final String token;
  final bool requiresOtp;
  final bool emailVerificationRequired;

  // ✅ FIXED: Remove positional parameter, use only named parameters
  RegistrationResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.token,
    this.requiresOtp = false,
    this.emailVerificationRequired = true, required String userEmail,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    print('🎯 Creating RegistrationResponse from JSON: $json');

    // Handle user data
    dynamic userData = json['user'];
    
    // Determine OTP requirement
    bool requiresOtp = json['requires_otp'] == true ||
        json['otp_required'] == true ||
        json['need_otp_verification'] == true;

    // Determine email verification requirement  
    bool emailVerificationRequired =
        json['email_verification_required'] == true ||
        json['email_verified'] == false ||
        json['needs_email_verification'] == true;

    return RegistrationResponse(
      status: json['status'] ?? 'success',
      message: json['message'] ?? '',
      user: userData,
      token: json['token'] ?? json['access_token'] ?? '',
      requiresOtp: requiresOtp,
      emailVerificationRequired: emailVerificationRequired, userEmail: '',
    );
  }

  // ✅ Helper method to get user email safely
  String get userEmail {
    if (user is String) {
      return user as String;
    } else if (user is Map) {
      return user['email'] ?? '';
    }
    return '';
  }

  // ✅ Helper method to check if user data is available as Map
  bool get hasUserData => user is Map;

  // ✅ Helper method to get UserData object (if available)
  // UserData? get userData {
  //   if (user is Map) {
  //     try {
  //       return UserData.fromJson(user as Map<String, dynamic>);
  //     } catch (e) {
  //       print('❌ Error creating UserData: $e');
  //       return null;
  //     }
  //   }
  //   return null;
  // }

  bool get isSuccess => status == 'success';

  @override
  String toString() {
    return 'RegistrationResponse{status: $status, message: $message, userEmail: $userEmail, requiresOtp: $requiresOtp}';
  }
}