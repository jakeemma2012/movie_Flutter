import 'package:hive/hive.dart';
import 'package:movieappprj/Models/User.dart';
import 'package:movieappprj/Models/ViewingHistory.dart';

class ViewingHistoryRepository {
  final Box<ViewingHistory> historyBox = Hive.box<ViewingHistory>(
    'viewingHistoryBox',
  );

  User? user = User.getUser;

  void addMovie(int videoId) {
    historyBox.put(
      '${user?.id}_$videoId',
      ViewingHistory(userId: user!.id, videoId: videoId, progress: 0),
    );
  }

  void updateViewingProgress(int videoId, double progress) {
    final existing = historyBox.values.firstWhere(
      (history) => history.userId == user?.id && history.videoId == videoId,
      orElse:
          () => ViewingHistory(
            userId: user!.id,
            videoId: videoId,
            progress: progress,
          ),
    );
    existing.progress = progress;
    historyBox.put('${user?.id}_$videoId', existing);
  }

  List<ViewingHistory> getViewingHistory(int userId) {
    return historyBox.values
        .where((history) => history.userId == userId)
        .toList();
  }
}
