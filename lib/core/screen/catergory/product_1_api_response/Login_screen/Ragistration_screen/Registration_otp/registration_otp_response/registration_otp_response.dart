class UserModelZX {
  final String message;
  final String token;
  final Userwer user;

  UserModelZX({
    required this.message,
    required this.token,
    required this.user,
  });

  factory UserModelZX.fromJson(Map<String, dynamic> json) {
    return UserModelZX(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: Userwer.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'user': user.toJson(),
    };
  }
}

class Userwer {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String phone;
  final String email;
  final String? image;
  final String fullName;

  Userwer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.phone,
    required this.email,
    this.image,
    required this.fullName,
  });

  factory Userwer.fromJson(Map<String, dynamic> json) {
    return Userwer(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      fullName: json['full_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'phone': phone,
      'email': email,
      'image': image,
      'full_name': fullName,
    };
  }
}