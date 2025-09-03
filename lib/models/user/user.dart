/// id : 5
/// name : "bulbul Ahmed"
/// email : "bulbul_dev_owner@yopmail.com"
/// email_verified : 1
/// email_verified_at : "2023-08-12T12:27:30.000000Z"
/// status : 1
/// profile_is_update : 1
/// created_at : "2023-08-12T12:22:50.000000Z"
/// updated_at : "2023-08-12T12:53:35.000000Z"

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.emergencyContact,
    this.presentAddress,
    this.permanentAddress,
    this.photo,
    this.licenseImage,
    this.emailVerified,
    this.emailVerifiedAt,
    this.status,
    this.profileIsUpdate,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emergencyContact = json['emergency_contact'];
    presentAddress = json['present_address'];
    permanentAddress = json['permanent_address'];
    licenseNo = json['driver_license_number'];
    photo = json['photo'];
    licenseImage = json['license_image'];
    emailVerified = json['email_verified'];
    emailVerifiedAt = json['email_verified_at'];
    status = json['status'];
    profileIsUpdate = json['profile_is_update'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  int? id;
  String? name;
  String? email;
  String? phone;
  String? emergencyContact;
  String? presentAddress;
  String? permanentAddress;
  String? licenseNo;
  String? photo;
  String? licenseImage;
  int? emailVerified;
  String? emailVerifiedAt;
  int? status;
  int? profileIsUpdate;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['emergency_contact'] = emergencyContact;
    map['present_address'] = presentAddress;
    map['permanent_address'] = permanentAddress;
    map['nid'] = licenseNo;
    map['photo'] = photo;
    map['license_image'] = licenseImage;
    map['email_verified'] = emailVerified;
    map['email_verified_at'] = emailVerifiedAt;
    map['status'] = status;
    map['profile_is_update'] = profileIsUpdate;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
