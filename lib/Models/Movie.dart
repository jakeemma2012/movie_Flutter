class Movie {
  final int movieId;
  final String title;
  final double rating;
  final String overview;
  final String genres;
  final String status;
  final String studio;
  final String director;
  final List<dynamic> movieCast;
  final int releaseYear;
  final String imageUrl;
  final String videoUrl;
  final String backdropUrl;
  final int duration;

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
      movieCast: json['movieCast'],
      releaseYear: json['releaseYear'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      backdropUrl: json['backdropUrl'],
      duration: json['duration'],
    );
  }
}
