import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieappprj/Utils/constants.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class SideMenuList extends StatelessWidget {
  const SideMenuList({super.key, required this.menuKey});
  final GlobalKey<SideMenuState> menuKey;
  @override
  Widget build(BuildContext context) {
    final dark = Util.isDarkMode(context);
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
                'Menu Header Jake',
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
            },
          ),
          ListTile(
            leading: Icon(
              Icons.movie,
              color: dark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Movies',
              style: TextStyle(color: dark ? Colors.white : Colors.black),
            ),
            onTap: () {
              menuKey.currentState?.closeSideMenu();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: dark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Settings',
              style: TextStyle(color: dark ? Colors.white : Colors.black),
            ),
            onTap: () {
              menuKey.currentState?.closeSideMenu();
            },
          ),
        ],
      ),
    );
  }
}
