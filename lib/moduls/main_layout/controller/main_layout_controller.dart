import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/core/helper/share_helper.dart';

class MainLayoutController extends GetxController {
  final PageController pageController = PageController(initialPage: 0);
  final RxInt currentIndex = 0.obs;

  late GlobalKey<ScaffoldState> mainLayoutKey;

  @override
  void onInit() {
    super.onInit();
    mainLayoutKey = GlobalKey<ScaffoldState>();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changePage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(index, duration: const Duration(microseconds: 500), curve: Curves.easeIn);
  }

  void logout() {
    ShareHelper.logout();
  }
}
