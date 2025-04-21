import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movieappprj/Function/_bottom_NAV.dart';
import 'package:movieappprj/Models/Movie.dart';
import 'package:movieappprj/Services/DatabaseService.dart';
import 'package:movieappprj/Services/ImageService.dart';
import 'package:movieappprj/Utils/constants.dart';
import 'package:movieappprj/Screen_New/_Detail_Movie.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Movie> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteMovies();
  }

  Future<void> _loadFavoriteMovies() async {
    try {
      final movies = await DatabaseService.getFavorite();
      if (mounted) {
        setState(() {
          favoriteMovies = movies;
        });
      }
    } catch (e) {
      print('Error loading favorite movies: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load favorite movies: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Util.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: BottomNav(),
      backgroundColor: dark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          'Favorite Movies',
          style: GoogleFonts.merriweather(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dark ? Colors.white : Util.TitleColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: dark ? Colors.black : Colors.white,
      ),
      body:
          favoriteMovies.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.heart,
                      size: 60,
                      color: dark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favorite movies yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: dark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favoriteMovies.length,
                itemBuilder: (context, index) {
                  final movie = favoriteMovies[index];
                  return Card(
                    color: dark ? Colors.grey[900] : Colors.white,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: Container(
                        width: 60,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: dark ? Colors.grey[800] : Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: FutureBuilder<String>(
                            future: ImageService.getImageUrl(
                              movie.imageUrl,
                              "poster",
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 30,
                                );
                              }
                              return Image.network(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) {
                                  return Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 30,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      title: Text(
                        movie.title,
                        style: TextStyle(
                          color: dark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Iconsax.star1,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${movie.rating.toStringAsFixed(1)}/10",
                                style: TextStyle(
                                  color:
                                      dark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Util.formatDuration(movie.duration),
                            style: TextStyle(
                              color: dark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Iconsax.heart, color: Colors.red),
                        onPressed: () async {
                          try {
                            await DatabaseService.removeFromFavorite(
                              movie.movieId,
                            );
                            _loadFavoriteMovies();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Removed from favorites'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Failed to remove from favorites: $e',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      onTap: () {
                        Get.to(() => DetailMovie(movie: movie));
                      },
                    ),
                  );
                },
              ),
    );
  }
}
