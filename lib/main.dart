import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movieappprj/Screen_New/Screen_HOME.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const ScreenHome(),
    );
  }
}
