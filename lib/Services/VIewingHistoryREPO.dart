// lib/Services/ViewingHistoryService.dart
import 'dart:async';

import 'package:hive/hive.dart';
import 'package:movieappprj/Models/ViewingHistory.dart';
import 'package:movieappprj/Models/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Global.dart';

class ViewingHistoryService {
  static const String _boxName = 'viewingHistoryBox';
  static Box<ViewingHistory>? _box;
  static Timer? _syncTimer;
  // Khởi tạo Hive box
  static Future<void> init() async {
    _box = await Hive.openBox<ViewingHistory>(_boxName);
    _startPeriodicSync();
  }

  // Bắt đầu đồng bộ định kỳ
  static void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      syncWithServer();
    });
  }

  static Box<ViewingHistory> getBox() {
    return _box!;
  }

  // Lưu lịch sử xem
  static Future<void> saveHistory(ViewingHistory history) async {
    await _box?.put('${history.userId}_${history.videoId}', history);
  }

  // Lấy lịch sử xem của một phim
  static ViewingHistory? getHistory(int movieId) {
    return _box?.get('${User.getUserId()}_$movieId');
  }

  // Lấy tất cả lịch sử xem
  static List<ViewingHistory> getAllHistory() {
    return _box?.values.toList() ?? [];
  }

  // Cập nhật tiến độ xem
  static Future<void> updateProgress(
    int movieId,
    double progress,
    int position,
  ) async {
    final history = getHistory(movieId);
    if (history != null) {
      final updatedHistory = ViewingHistory(
        userId: history.userId,
        videoId: history.videoId,
        progress: progress,
        position: position,
        lastWatched: DateTime.now(),
        isSynced: false,
      );
      await saveHistory(updatedHistory);
    }
  }

  // Đồng bộ với server
  static Future<void> syncWithServer() async {
    final unsyncedHistory =
        _box?.values.where((h) => h.isSynced == false).toList() ?? [];
    print('Syncing ${unsyncedHistory.length} history');
    for (var history in unsyncedHistory) {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/history/update'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${User.getAccessToken()}',
          },
          body: jsonEncode({
            'userId': history.userId,
            'videoId': history.videoId,
            'progress': history.progress,
            'position': history.position,
            'lastWatched': history.lastWatched?.toIso8601String() ?? '',
          }),
        );

        if (response.statusCode == 200) {
          // Đánh dấu đã đồng bộ
          final syncedHistory = ViewingHistory(
            userId: history.userId,
            videoId: history.videoId,
            progress: history.progress,
            position: history.position,
            lastWatched: history.lastWatched,
            isSynced: true,
          );
          await saveHistory(syncedHistory);
        }
      } catch (e) {
        print('Error syncing history: $e');
      }
    }
  }

  // Lấy lịch sử xem từ server
  static Future<void> fetchFromServer() async {
    try {
      print('Fetching history from server');
      final response = await http.get(
        Uri.parse('$baseUrl/history/${User.getUserId()}'),
        headers: {'Authorization': 'Bearer ${User.getAccessToken()}'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        for (var item in data) {
          final history = ViewingHistory(
            userId: item['userId'],
            videoId: item['videoId'],
            progress: item['progress'].toDouble(),
            position: item['position'],
            lastWatched: DateTime.parse(item['lastWatched']),
            isSynced: true,
          );
          await saveHistory(history);
        }
      }
    } catch (e) {
      print('Error fetching history: $e');
    }
  }
}
