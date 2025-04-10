import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with SingleGetTickerProviderMixin {
  static LoginController get instance => Get.find();

  late AnimationController animationController;
  late Animation<double> animation;

  LoginController() {
    // Khởi tạo AnimationController
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Khởi tạo Animation với CurvedAnimation
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void onInit() {
    super.onInit();
    // Bắt đầu animation khi controller được khởi tạo
    animationController.forward();
  }

  @override
  void onClose() {
    // Giải phóng tài nguyên khi controller không còn sử dụng
    animationController.dispose();
    super.onClose();
  }
}