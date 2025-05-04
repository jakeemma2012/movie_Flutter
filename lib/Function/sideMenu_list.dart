import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:movieappprj/Function/_bottom_NAV.dart';
import 'package:movieappprj/Screen/Home_Screen.dart';
import 'package:movieappprj/Screen_New/Screen_HOME.dart';
import 'package:movieappprj/Screen_New/_FavoritePage.dart';
import 'package:movieappprj/Screen_New/_ProfilePage.dart';
import 'package:movieappprj/Screen_New/_SearchPage.dart';
import 'package:movieappprj/Utils/constants.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class SideMenuList extends StatelessWidget {
  const SideMenuList({super.key, required this.menuKey});
  final GlobalKey<SideMenuState> menuKey;
  @override
  Widget build(BuildContext context) {
    final dark = Util.isDarkMode(context);
    final controller = Get.put(NavigationController());
    return Container(
      width: 250,
      color: dark ? Colors.black : Colors.white,
      child: Column(
        children: [
          Container(
            height: 100,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Menu Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: dark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: dark ? Colors.white : Colors.black),
            ),
            onTap: () {
              menuKey.currentState?.closeSideMenu();
              controller.changeIndex(0);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: dark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Favorite',
              style: TextStyle(color: dark ? Colors.white : Colors.black),
            ),
            onTap: () {
              menuKey.currentState?.closeSideMenu();
              controller.changeIndex(1);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              color: dark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Search',
              style: TextStyle(color: dark ? Colors.white : Colors.black),
            ),
            onTap: () {
              menuKey.currentState?.closeSideMenu();
              controller.changeIndex(2);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: dark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Profile',
              style: TextStyle(color: dark ? Colors.white : Colors.black),
            ),
            onTap: () {
              menuKey.currentState?.closeSideMenu();
              controller.changeIndex(3);
            },
          ),
        ],
      ),
    );
  }
}
