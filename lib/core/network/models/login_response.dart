class LoginResponse {
  bool? success;
  LoginData? data;
  String? message;

  LoginResponse({this.success, this.data, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) map['data'] = data!.toJson();
    map['message'] = message;
    return map;
  }
}

class LoginData {
  User? user;
  String? token;

  LoginData({this.user, this.token});

  LoginData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user'] = user;
    map['token'] = token;
    return map;
  }
}

// Simple User model
class User {
  int? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    return map;
  }
}
