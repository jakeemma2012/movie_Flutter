import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:movieappprj/Screen_New/_FavoritePage.dart';
import 'package:movieappprj/Screen_New/_HomePage.dart';
import 'package:movieappprj/Screen_New/_ProfilePage.dart';
import 'package:movieappprj/Screen_New/_SearchPage.dart';

class BottomNav extends StatelessWidget {
  BottomNav({super.key});

  final Rx<int> selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return NavigationBar(
      height: 60,
      elevation: 0,
      selectedIndex: controller.selectedIndex.value,
      onDestinationSelected: (index) {
        controller.changeIndex(index);
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorite'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        Get.to(() => const HomePageScreen());
        break;
      case 1:
        Get.to(() => const FavoritePage());
        break;
      case 2:
        Get.to(() => const SearchPage());
        break;
      case 3:
        Get.to(() => const ProfilePage());
        break;
    }
  }
}
