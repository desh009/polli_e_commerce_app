// lib/core/models/epic_user_model.dart
class EpicUserData {
  final int userId;
  final String givenName;
  final String familyName;
  final String userHandle;
  final String mobileNumber;
  final String emailAddress;
  final String? profilePicture;
  final int isEmailConfirmed;
  final String? emailConfirmationTime;
  final String? confirmationCode;
  final int accountStatus;
  final String accountCreationTime;
  final String lastUpdatedTime;
  final String completeName;

  EpicUserData({
    required this.userId,
    required this.givenName,
    required this.familyName,
    required this.userHandle,
    required this.mobileNumber,
    required this.emailAddress,
    this.profilePicture,
    required this.isEmailConfirmed,
    this.emailConfirmationTime,
    this.confirmationCode,
    required this.accountStatus,
    required this.accountCreationTime,
    required this.lastUpdatedTime,
    required this.completeName,
  });

  factory EpicUserData.fromJson(Map<String, dynamic> json) {
    return EpicUserData(
      userId: json['id'] ?? 0,
      givenName: json['first_name'] ?? '',
      familyName: json['last_name'] ?? '',
      userHandle: json['username'] ?? '',
      mobileNumber: json['phone'] ?? '',
      emailAddress: json['email'] ?? '',
      profilePicture: json['image'],
      isEmailConfirmed: json['email_verified'] ?? 0,
      emailConfirmationTime: json['email_verified_at'],
      confirmationCode: json['verification_code'],
      accountStatus: json['status'] ?? 0,
      accountCreationTime: json['created_at'] ?? '',
      lastUpdatedTime: json['updated_at'] ?? '',
      completeName: json['full_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'first_name': givenName,
      'last_name': familyName,
      'username': userHandle,
      'phone': mobileNumber,
      'email': emailAddress,
      'image': profilePicture,
      'email_verified': isEmailConfirmed,
      'email_verified_at': emailConfirmationTime,
      'verification_code': confirmationCode,
      'status': accountStatus,
      'created_at': accountCreationTime,
      'updated_at': lastUpdatedTime,
      'full_name': completeName,
    };
  }
}
