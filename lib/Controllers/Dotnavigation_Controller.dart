import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movieappprj/Screen_New/Screen_RSG_LOGIN.dart';

class Dotnavigation_Controller extends GetxController {
  static Dotnavigation_Controller get instance => Get.find();

  final pagecontroller = PageController();
  Rx<int> curentIndex = 0.obs;

  void UpdateIndicator(index) => curentIndex.value = index;

  void dotNavigatorClick(index) {
    curentIndex.value = index;
    pagecontroller.jumpTo(index);
  }

  void nextPage() {
    if (curentIndex.value == 2) {
      curentIndex.value = 0;
      pagecontroller.jumpToPage(0);
      // Get.to(ScreenLogin());
    } else {
      int page = curentIndex.value += 1;
      pagecontroller.jumpToPage(page);
    }
  }

  void SkipButton(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ScreenRsgLogin()),
      // MaterialPageRoute(builder: (context) => const HiddenMenuScreen()),
    );
  }
}
