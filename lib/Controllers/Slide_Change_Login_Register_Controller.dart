import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class SlideChangeLoginRegisterController extends AnimationController {
  static SlideChangeLoginRegisterController get instance => Get.find();

  late Animation<Offset> slideAnimation;
  late AnimationController controller;

  SlideChangeLoginRegisterController({required TickerProvider vsync})
: super(vsync: vsync) {
    controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: vsync,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(1, 0),
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  void startAnimation() {
    controller.forward();
  }

  void stopAnimation() {
    controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
