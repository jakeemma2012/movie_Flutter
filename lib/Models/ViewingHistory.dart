import 'package:hive/hive.dart';

part 'ViewingHistory.g.dart';

@HiveType(typeId: 1)
class ViewingHistory extends HiveObject {
  @HiveField(0)
  int userId;

  @HiveField(1)
  int videoId;

  @HiveField(2)
  double progress;

  @HiveField(3)
  int position;

  @HiveField(4)
  DateTime? lastWatched;

  @HiveField(5)
  bool? isSynced;

  ViewingHistory({
    required this.userId,
    required this.videoId,
    required this.progress,
    required this.position,
    DateTime? lastWatched,
    bool? isSynced,
  }) : lastWatched = lastWatched ?? DateTime.now(),
       isSynced = isSynced ?? false;
}
