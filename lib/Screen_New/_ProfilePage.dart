import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movieappprj/Function/_bottom_NAV.dart';
import 'package:movieappprj/Function/sideMenu_list.dart';
import 'package:movieappprj/Models/User.dart';
import 'package:movieappprj/Utils/constants.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();
  @override
  Widget build(BuildContext context) {
    final dark = Util.isDarkMode(context);
    final size = MediaQuery.of(context).size;
    final user = User.getUser;

    return SideMenu(
      key: sideMenuKey,
      background: Colors.black.withOpacity(0.5),
      menu: SideMenuList(menuKey: sideMenuKey),
      child: Builder(
        builder: (context) {
          final isMenuOpen = sideMenuKey.currentState?.isOpened ?? false;
          return AbsorbPointer(
            absorbing: isMenuOpen,
            child: GestureDetector(
              onTap: () {
                if (isMenuOpen) {
                  sideMenuKey.currentState?.closeSideMenu();
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Profile User",
                    style: GoogleFonts.merriweather(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.black,
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: dark ? Colors.black : Colors.white,
                  leading: IconButton(
                    onPressed: () {
                      if (isMenuOpen) {
                        sideMenuKey.currentState?.closeSideMenu();
                      } else {
                        sideMenuKey.currentState?.openSideMenu();
                      }
                    },
                    icon: Icon(
                      Iconsax.menu_board,
                      color: dark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                bottomNavigationBar: BottomNav(),
                backgroundColor: dark ? Colors.black : Colors.white,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Header
                      Container(
                        width: size.width,
                        height: size.height * 0.3,
                        decoration: BoxDecoration(
                          color: dark ? Colors.grey[900] : Colors.grey[200],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Avatar
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    dark ? Colors.grey[800] : Colors.grey[300],
                              ),
                              child: Icon(
                                Iconsax.user,
                                size: 50,
                                color:
                                    dark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Username
                            Text(
                              user!.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: dark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Email
                            Text(
                              user.email,
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    dark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Settings Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // Dark Mode Toggle
                            _buildSettingItem(
                              icon: Iconsax.moon,
                              title: 'Dark Mode',
                              trailing: Switch(
                                value: Util.darkmode,
                                onChanged: (value) {
                                  Util.toggleDarkMode();
                                  setState(() {});
                                },
                              ),
                            ),
                            const Divider(),
                            // Notifications
                            _buildSettingItem(
                              icon: Iconsax.notification,
                              title: 'Notifications',
                              trailing: const Icon(Iconsax.arrow_right_3),
                            ),
                            const Divider(),
                            // Language
                            _buildSettingItem(
                              icon: Iconsax.global,
                              title: 'Language',
                              trailing: const Icon(Iconsax.arrow_right_3),
                            ),
                            const Divider(),
                            // Help & Support
                            _buildSettingItem(
                              icon: Iconsax.message_question,
                              title: 'Help & Support',
                              trailing: const Icon(Iconsax.arrow_right_3),
                            ),
                            const Divider(),
                            // About
                            _buildSettingItem(
                              icon: Iconsax.info_circle,
                              title: 'About',
                              trailing: const Icon(Iconsax.arrow_right_3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Logout Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement logout
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    final dark = Util.isDarkMode(context);

    return ListTile(
      leading: Icon(icon, color: dark ? Colors.grey[400] : Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(
          color: dark ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
      trailing: trailing,
      onTap: () {},
    );
  }
}
