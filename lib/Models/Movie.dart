import 'package:hive/hive.dart';

part 'Movie.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  int movieId;

  @HiveField(1)
  String title;

  @HiveField(2)
  double rating;

  @HiveField(3)
  String overview;

  @HiveField(4)
  String genres;

  @HiveField(5)
  String status;

  @HiveField(6)
  String studio;

  @HiveField(7)
  String director;

  @HiveField(8)
  List<String> movieCast;

  @HiveField(9)
  int releaseYear;

  @HiveField(10)
  String imageUrl;

  @HiveField(11)
  String videoUrl;

  @HiveField(12)
  String backdropUrl;

  @HiveField(13)
  int duration;

  Movie({
    required this.movieId,
    required this.title,
    required this.rating,
    required this.overview,
    required this.genres,
    required this.status,
    required this.studio,
    required this.director,
    required this.movieCast,
    required this.releaseYear,
    required this.imageUrl,
    required this.videoUrl,
    required this.duration,
    required this.backdropUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      movieId: json['movieId'],
      title: json['title'],
      rating: json['rating'],
      overview: json['overviewString'],
      genres: json['genres'],
      status: json['status'],
      studio: json['studio'],
      director: json['director'],
      movieCast: List<String>.from(json['movieCast']),
      releaseYear: json['releaseYear'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      backdropUrl: json['backdropUrl'],
      duration: json['duration'],
    );
  }
}
