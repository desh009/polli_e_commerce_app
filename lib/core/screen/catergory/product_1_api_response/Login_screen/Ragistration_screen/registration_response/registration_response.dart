class RegistrationResponse {
  final String status;
  final String message;
  final UserData user;
  final String token;
  final bool requiresOtp;
  final bool emailVerificationRequired;

  RegistrationResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.token,
    this.requiresOtp = false,
    this.emailVerificationRequired = true,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      user: UserData.fromJson(json['user']),
      token: json['token'] ?? '',
      requiresOtp:
          json['requires_otp'] == true ||
          json['otp_required'] == true ||
          json['need_otp_verification'] == true ||
          json['phone_verification_required'] == true,
      emailVerificationRequired:
          json['email_verification_required'] == true ||
          json['email_verified'] == false ||
          json['needs_email_verification'] == true ||
          (json['user'] != null && json['user']['email_verified'] == 0), // ✅ 0 means not verified
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'user': user.toJson(),
      'token': token,
      'requires_otp': requiresOtp,
      'email_verification_required': emailVerificationRequired,
    };
  }

  bool get isSuccess => status == 'success';
}

class UserData {
  final String firstName;
  final String lastName;
  final String username;
  final String phone;
  final String email;
  final String verificationCode;
  final int emailVerified; // ✅ int type (0/1)
  final String updatedAt;
  final String createdAt;
  final int id;
  final String fullName;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.phone,
    required this.email,
    required this.verificationCode,
    required this.emailVerified,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.fullName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      verificationCode: json['verification_code'] ?? '',
      emailVerified: json['email_verified'] ?? 0, // ✅ int value
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'phone': phone,
      'email': email,
      'verification_code': verificationCode,
      'email_verified': emailVerified,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
      'full_name': fullName,
    };
  }

  // ✅ CORRECT: Convert int to bool for easy checking
  bool get isEmailVerified => emailVerified == 1;
}