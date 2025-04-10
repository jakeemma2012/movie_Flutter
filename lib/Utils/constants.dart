// all asset link root
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Util {
  static const String Logo = "assets/images/banner/movie_logo.png";

  static const String Logo1 = "assets/images/banner/pos_WhenThePhoneRings.jpg";

  static const String Logo2 = "assets/images/banner/Transformer5.jpg";

  static const String google = "assets/images/google.png";

  static const String facebook = "assets/images/facebook.png";

  static const String LOGO_TITLE = "assets/images/logo_title.png";

  static const double sizeBtw2Text = 16.0;

  static const double defaultSpace = 24.0;

  static const double appBarHeight = 56.0;

  static const double iconSize = 24.0;

  static const Color TitleColor = Color(0xFF110E47);

  static const Color BackgroundColor = Color(0xFF88A4E8);

  static double ScrrenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double ScreenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  static bool isDarkMode(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }

  static double getBottomNavigationBarHeight(){
    return kBottomNavigationBarHeight;
  }

}
