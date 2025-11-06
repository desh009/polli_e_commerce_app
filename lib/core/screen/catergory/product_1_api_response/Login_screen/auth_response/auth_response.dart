// lib/core/models/epic_login_response.dart
import 'package:polli_e_commerce_app/core/screen/catergory/product_1_api_response/Login_screen/login_response/login_response.dart';

class EpicAuthResponse {
  final String responseStatus;
  final String message;
  final EpicUserData userData;
  final String authToken;

  EpicAuthResponse({
    required this.responseStatus,
    required this.message,
    required this.userData,
    required this.authToken,
  });

  factory EpicAuthResponse.fromJson(Map<String, dynamic> json) {
    return EpicAuthResponse(
      responseStatus: json['status'] ?? '',
      message: json['message'] ?? '',
      userData: EpicUserData.fromJson(json['user'] ?? {}), // ✅ Null safety fix
      authToken: json['token'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': responseStatus,
      'message': message,
      'user': userData.toJson(),
      'token': authToken,
    };
  }

  bool get isSuccess => responseStatus == 'success';
}