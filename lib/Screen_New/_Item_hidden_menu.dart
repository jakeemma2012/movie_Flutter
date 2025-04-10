import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:movieappprj/Screen_New/_HomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movieappprj/Utils/constants.dart';

class HiddenMenuScreen extends StatefulWidget {
  const HiddenMenuScreen({super.key});

  @override
  State<HiddenMenuScreen> createState() => _HiddenMenuScreenState();
}

class _HiddenMenuScreenState extends State<HiddenMenuScreen> {
  List<ScreenHiddenDrawer> _pages = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo trong initState
    _initializePages();
  }

  void _initializePages() {
    setState(() {
      _pages = [
        ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: "Home",
            baseStyle: TextStyle(
              fontSize: 20,
              color: Util.TitleColor,
            ),
            selectedStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Util.TitleColor,
            ),
          ),
          const HomePageScreen(),
        ),
      ];
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hiển thị loading khi chưa khởi tạo xong
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async => false, // Ngăn back button
      child: HiddenDrawerMenu(
        backgroundColorMenu: Util.BackgroundColor,
        backgroundColorAppBar: Util.BackgroundColor,
        elevationAppBar: 0,
        screens: _pages,
        initPositionSelected: 0,
        slidePercent: 40,
        contentCornerRadius: 20,
        tittleAppBar: Text(
          'Home Page',
          style: GoogleFonts.merriweather(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Util.TitleColor,
          ),
        ),
        typeOpen: TypeOpen.FROM_LEFT,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 10,
          ),
        ],
        actionsAppBar: [
          IconButton(
            onPressed: () {
              print("Search button pressed");
            },
            icon: Icon(Iconsax.search_normal, color: Util.TitleColor),
          ),
          IconButton(
            onPressed: () {
              print("Notification button pressed");
            },
            icon: Icon(Iconsax.notification, color: Util.TitleColor),
          ),
        ],
      ),
    );
  }
}
