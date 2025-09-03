
import 'dart:convert';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/constant/app_constant.dart';
import 'package:polli_e_commerce_app/models/user/user.dart';
import 'package:polli_e_commerce_app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';


class ShareHelper {
  static late SharedPreferences prefs;
  static init() async {
    await SharedPreferences.getInstance().then((pr) {
      prefs = pr;
    });
  }

  ShareHelper();

  ShareHelper.getAuthToken(String token){
    token = prefs.getString(AppConstant.authToken)??"";
  }

  ShareHelper.setAuthToken(String ot){
    prefs.setString(AppConstant.authToken, ot);
  }

  static void setUser(User? user) {
    prefs.setString(AppConstant.user, json.encode(user?.toJson()));
  }

  ShareHelper.setIntro(){
    prefs.setBool(AppConstant.intro, true);
  }

  static bool getIntro(){
    return prefs.getBool(AppConstant.intro)??false;
  }

  static User? getUser(User? user) {
    if (prefs.containsKey(AppConstant.user)) {
      user = User.fromJson(json.decode(prefs.getString(AppConstant.user).toString()));
      return user;
    } else {
      return null;
    }
  }

  static void clear() {
    prefs.clear();
    ShareHelper.setIntro();
  }

  static void logout() {
    clear();
    Get.offAllNamed(Routes.AUTH);
  }


}
