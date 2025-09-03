import 'package:get/get.dart';

class DrawerControllerX extends GetxController {
  var selectedItem = ''.obs; // কোন item select হয়েছে সেটা রাখবে

  void setSelected(String item) {
    selectedItem.value = item;
  }
}
