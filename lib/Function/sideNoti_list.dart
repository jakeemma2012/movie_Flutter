import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieappprj/Utils/constants.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class SideNotiList extends StatelessWidget {
  const SideNotiList({super.key, required this.notificationMenuKey});
  final GlobalKey<SideMenuState> notificationMenuKey;

  @override
  Widget build(BuildContext context) {
    final dark = Util.isDarkMode(context);
    return Container(
      width: 300,
      color: dark ? Colors.black : Colors.white,
      child: Column(
        children: [
          Container(
            height: 60,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildNotificationItem(
                  'New Movie Jake Release',
                  'Dune: Part Two is now available',
                  Icons.movie,
                  dark,
                ),
                _buildNotificationItem(
                  'Ticket Confirmation',
                  'Your ticket for Oppenheimer has been confirmed',
                  Icons.confirmation_number,
                  dark,
                ),
                _buildNotificationItem(
                  'Special Offer',
                  'Get 20% off on your next booking',
                  Icons.local_offer,
                  dark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String message,
    IconData icon,
    bool dark,
  ) {
    return ListTile(
      leading: Icon(icon, color: dark ? Colors.white : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: dark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        message,
        style: TextStyle(color: dark ? Colors.grey[400] : Colors.grey[700]),
      ),
      onTap: () {
        notificationMenuKey.currentState?.closeSideMenu();
      },
    );
  }
}
