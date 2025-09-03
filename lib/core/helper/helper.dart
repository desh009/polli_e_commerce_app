import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/constant/app_constant.dart';



enum ServerDateTime { Date, Time, Both}


class Helper{


  static Future<String?> openDatePicker({String date='',DateTime? lastDate}) async {
    DateTime selectedDate;
    try {
      selectedDate = date.isNotEmpty ? DateTime.parse(date) : DateTime.now();
    } catch (e) {
      selectedDate = DateTime.now();
    }
    final DateTime? picked = await showDatePicker(
        context: Get.context!,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        locale: Locale('en'),
        lastDate: lastDate ?? DateTime(2101));
    if (picked != null && picked != selectedDate) {
      // return AppConstant.defaultDateFormat.format(picked);
    } else {
      return null;
    }
  }

  static Future<String> openTimePicker({required BuildContext context, String? selectedTime}) async {
      TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      // initialTime: selectedTime == null ? TimeOfDay.now() : TimeOfDay.fromDateTime(DateFormat.jm().parse(selectedTime)),
      builder: (BuildContext context, Widget? child) {
        // We just wrap these environmental changes around the
        // child in this builder so that we can apply the
        // options selected above. In regular usage, this is
        // rarely necessary, because the default values are
        // usually used as-is.
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: false,
          ),
          child: child!,
        );
      }, initialTime: TimeOfDay.now(),
    );
    if (timeOfDay != null) {
      return timeOfDay.format(context);
    } else {
      return '';
    }
  }

  // static getDate(String date){
  //   return DateFormat('dd MMM yyyy hh:mm a').format(DateTime.parse(date));
  // }

  // static goBrowser(String url) async {
  //   if (!await launchUrl(
  //     Uri.parse(url),
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw 'Could not launch $url';
  //   }
  // }
  // static makeCall(String number) async {
  //   canLaunchUrl(Uri(scheme: 'tel', path: number)).then((bool result) async{
  //     final Uri launchUri = Uri(
  //       scheme: 'tel',
  //       path: number,
  //     );
  //     await launchUrl(launchUri);
  //   });
  // }
  //
  // static String getTimeDifference(String dateTime){
  //   return timeago.format(DateTime.parse(dateTime));
  // }



  static bool isEmailValid(String email) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }

  static bool isPhoneValid(String phone) {
    bool phoneValid = RegExp(r"(^([+]{1}[8]{2}|0088)?(01){1}[3-9]{1}\d{8})$").hasMatch(phone);
    print(phoneValid);
    return phoneValid;
  }

  // static getColor(String status){
  //   switch(status){
  //     case "Pending":
  //       return AppColors.primary;
  //     case "Approved":
  //       return AppColors.green;
  //     case "Rejected":
  //       return AppColors.red;
  //     default:
  //       return AppColors.primary;
  //   }
  // }
  static textCopy({required String text}) {
    Clipboard.setData( ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Copied to your clipboard !')));
    });
  }




  // static Future<void> share(String? text, {String? subject,List<String>? imagePaths}) async {
  //   final box = Get.context!.findRenderObject() as RenderBox?;
  //
  //   if (imagePaths!=null && imagePaths.isNotEmpty) {
  //     await Share.shareFiles(imagePaths,
  //         text: text,
  //         subject: subject,
  //         sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  //   } else {
  //     await Share.share(text??"",
  //         subject: subject,
  //         sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  //   }
  // }
  //
  //

  // static checkConnectivity(){
  //   if(appConnectivityResult!.value == ConnectivityResult.none){
  //     ErrorMessage(message: language.Check_Your_Internet_Connection);
  //     return;
  //   }
  // }




}