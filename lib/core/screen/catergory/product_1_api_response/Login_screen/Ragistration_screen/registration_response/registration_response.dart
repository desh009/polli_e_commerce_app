// lib/core/screen/catergory/product_1_api_response/Login_screen/Registration_screen/model/registration_response.dart
class RegistrationResponse {
  final String status;
  final String message;
  final UserData user;
  final String token;

  RegistrationResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.token,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      user: UserData.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'user': user.toJson(),
      'token': token,
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
  final int emailVerified;
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
      emailVerified: json['email_verified'] ?? 0,
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

  bool get isEmailVerified => emailVerified == 1;
}