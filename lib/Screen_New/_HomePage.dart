import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movieappprj/Models/Movie.dart';
import 'package:movieappprj/Services/DatabaseService.dart';
import 'package:movieappprj/Services/Global.dart';
import 'package:movieappprj/Utils/constants.dart';

String _formatDuration(int totalMinutes) {
  if (totalMinutes <= 0) {
    return '';
  }
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  final hoursString = hours > 0 ? '${hours}h ' : '';
  final minutesString = minutes > 0 ? '${minutes}m' : '';
  if (hours > 0 && minutes == 0) {
    return '${hours}h';
  }
  if (hours == 0 && minutes > 0) {
    return '${minutes}m';
  }
  return '$hoursString$minutesString'.trim();
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<Movie> nowShowing = [];
  List<Movie> popular = [];

  @override
  void initState() {
    super.initState();
    _loadNowShowingMovies();
    _loadPopularMovies();
  }

  Future<void> _loadNowShowingMovies() async {
    try {
      final movies = await DatabaseService.getNowShowing();
      if (mounted) {
        setState(() {
          nowShowing = movies;
        });
      }
    } catch (e) {
      print('Error loading movies: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load movies: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadPopularMovies() async {
    try {
      final movies = await DatabaseService.getNowShowing();
      if (mounted) {
        setState(() {
          popular = movies;
        });
      }
    } catch (e) {
      print('Error loading popular movies: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load popular movies: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Util.isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: dark ? Colors.black : Colors.white,

        appBar: _AppBar_Widget(dark),

        body: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                _Title_showing_and_button_See_all(dark),

                const SizedBox(height: 10),

                _image_NowShowing(dark, nowShowing),

                const SizedBox(height: 25),

                _Title_Pupular_and_See_all(dark),

                const SizedBox(height: 15),

                _buildPopularList(context, dark, nowShowing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopularList(
    BuildContext context,
    bool dark,
    List<Movie> popularMovies,
  ) {
    if (popularMovies.isEmpty) {
      return SizedBox(
        height: 150,
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      separatorBuilder: (context, index) => SizedBox(height: 20),
      itemBuilder: (context, index) {
        final movie = popularMovies[index];
        List<String> genreList =
            movie.genres
                .split(',')
                .map((g) => g.trim())
                .where((g) => g.isNotEmpty)
                .toList();

        return GestureDetector(
          onTap: () {
            print("Tapped index : $index, Movie: ${movie.title}");
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 125,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "$baseUrlCdn/api/get_images?linkImage=${movie.imageUrl}",
                    fit: BoxFit.cover,
                    loadingBuilder:
                        (context, child, progress) =>
                            progress == null
                                ? child
                                : Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                    errorBuilder:
                        (context, error, stack) => Icon(
                          Icons.movie,
                          color: Colors.grey[600],
                          size: 40,
                        ),
                  ),
                ),
              ),
              SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${movie.title} (${movie.releaseYear})",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: dark ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),

                    Row(
                      children: [
                        Icon(Iconsax.star1, color: Colors.amber, size: 18),
                        SizedBox(width: 5),
                        Text(
                          "${movie.rating.toStringAsFixed(1)}/10",
                          style: TextStyle(
                            fontSize: 14,
                            color: dark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children:
                          genreList
                              .map((genre) => _buildGenreChip(genre, dark))
                              .toList(),
                    ),
                    SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 18,
                          color: dark ? Colors.grey[400] : Colors.grey[700],
                        ),
                        SizedBox(width: 5),
                        Text(
                          _formatDuration(movie.duration),
                          style: TextStyle(
                            fontSize: 14,
                            color: dark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenreChip(String genre, bool dark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: dark ? Colors.grey[800] : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dark ? Colors.grey[700]! : Colors.blue[200]!,
          width: 0.5,
        ),
      ),
      child: Text(
        genre.toUpperCase(),
        style: TextStyle(
          color: dark ? Colors.grey[300] : Colors.blue[800],
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Row _Title_Pupular_and_See_all(bool dark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Popular",
          style: GoogleFonts.merriweather(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dark ? Colors.white : Util.TitleColor,
          ),
        ),

        // ignore: sized_box_for_whitespace
        Container(
          height: 30,
          width: 90,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "See All",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Column _image_NowShowing(bool dark, List<Movie> nowShowing) {
    if (nowShowing.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 320,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print("Tapped index : $index");
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey,
                          image: DecorationImage(
                            image: NetworkImage(
                              "$baseUrlCdn/api/get_images?linkImage=${nowShowing[index].imageUrl}",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: 140,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            nowShowing[index].title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Icon(Iconsax.star1, color: Colors.amber),
                          Text(
                            "${nowShowing[index].rating}/10",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Row _Title_showing_and_button_See_all(bool dark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Now Showing",
          style: GoogleFonts.merriweather(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dark ? Colors.white : Util.TitleColor,
          ),
        ),

        // ignore: sized_box_for_whitespace
        Container(
          height: 30,
          width: 90,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "See All",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  AppBar _AppBar_Widget(bool dark) {
    return AppBar(
      title: Text(
        'Home Page',
        style: GoogleFonts.merriweather(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: dark ? Colors.white : Util.TitleColor,
        ),
      ),
      centerTitle: true,
      backgroundColor: dark ? Colors.black : Colors.white,
      leading: IconButton(
        onPressed: () {
          //  SimpleHiddenDrawerController.of(context).toggle();
        },
        icon: Icon(
          Iconsax.menu_board,
          color: dark ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Iconsax.notification,
            color: dark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
