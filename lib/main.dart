import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movieappprj/Models/Movie.dart';
import 'package:movieappprj/Models/ViewingHistory.dart';
import 'package:movieappprj/Screen_New/Screen_HOME.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('movieBox');
  Hive.registerAdapter(ViewingHistoryAdapter());
  if (!Hive.isBoxOpen('viewingHistoryBox')) {
    var box = await Hive.openBox<ViewingHistory>('viewingHistoryBox');
    for (var i = 0; i < box.length; i++) {
      final history = box.getAt(i) as ViewingHistory;
      print(
        'User ${history.userId} watched video ${history.videoId} - Progress: ${history.progress}%',
      );
    }
  }
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
