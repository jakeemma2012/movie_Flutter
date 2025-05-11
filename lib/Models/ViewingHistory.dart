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

  ViewingHistory({
    required this.userId,
    required this.videoId,
    required this.progress,
  });
}
