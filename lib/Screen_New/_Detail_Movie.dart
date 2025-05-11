import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:movieappprj/Models/Movie.dart';
import 'package:movieappprj/Models/User.dart';
import 'package:movieappprj/Models/ViewingHistory.dart';
import 'package:movieappprj/Services/DatabaseService.dart';
import 'package:movieappprj/Services/ImageService.dart';
import 'package:movieappprj/Utils/constants.dart';
import 'package:better_player/better_player.dart';

class DetailMovie extends StatefulWidget {
  final Movie? movie;
  const DetailMovie({super.key, this.movie});

  @override
  State<DetailMovie> createState() => _DetailMovieState();
}

class _DetailMovieState extends State<DetailMovie> {
  List<String> _parseCast(dynamic castData) {
    if (castData == null) return [];
    try {
      if (castData is String) {
        final List<dynamic> castList = jsonDecode(castData);
        return List<String>.from(castList);
      } else if (castData is List) {
        return List<String>.from(castData);
      }
      return [];
    } catch (e) {
      print('Error parsing cast: $e');
      return [];
    }
  }

  BetterPlayerController? _betterPlayerController;
  bool isFavorite = false;
  var box = Hive.box<ViewingHistory>('viewingHistoryBox');

  Future<void> _playTrailer() async {
    try {
      final videoUrl = await ImageService.getAssets(
        widget.movie?.videoUrl ?? '',
        "video",
      );

      if (videoUrl.isNotEmpty) {
        final betterPlayerController = BetterPlayerController(
          BetterPlayerConfiguration(
            autoPlay: true,
            aspectRatio: 16 / 9,
            fit: BoxFit.contain,
            looping: false,
            errorBuilder: (context, errorMessage) {
              print("Error while loading video: $errorMessage");
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.white, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Error loading video',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage ?? 'Could not load the video stream.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          betterPlayerDataSource: BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            videoUrl,
            headers: {'User-Agent': 'Mozilla/5.0'},
          ),
        );

        betterPlayerController.addEventsListener((event) {
          print("BetterPlayer event: ${event.betterPlayerEventType}");
        });

        if (!mounted) return;

        // final history = ViewingHistory(userId: User.getUserId(), videoId: widget.movie?.movieId ?? 0, progress: 50.0);
        // await box.add(history);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            // ignore: deprecated_member_use
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                backgroundColor: Colors.black,
                contentPadding: EdgeInsets.zero,
                content: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(controller: betterPlayerController),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      betterPlayerController.dispose();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Đóng',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Video URL is empty. Please try again later.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('Error playing trailer: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        Navigator.of(context).pop(); // Close dialog nếu đã mở
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not play the video: $e'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _loadFavoriteMovies();
    super.initState();
  }

  Future<void> _loadFavoriteMovies() async {
    try {
      final movies = await DatabaseService.getFavorite();
      if (mounted) {
        setState(() {
          isFavorite = movies.any((m) => m.movieId == widget.movie?.movieId);
          print("FAVOR : $isFavorite");
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
    final dark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: dark ? Colors.black : Colors.white10,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trailer Section
              Stack(
                children: [
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: FutureBuilder<String>(
                      future: ImageService.getAssets(
                        widget.movie?.backdropUrl ?? '',
                        "backdrop",
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.white,
                            ),
                          );
                        }
                        return Image.network(snapshot.data!, fit: BoxFit.cover);
                      },
                    ),
                  ),

                  // Play Trailer Button
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _playTrailer,
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 32,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Watch Trailer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Top Bar
                  Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircleButton(Icons.arrow_back, () {
                            Navigator.pop(context);
                          }),
                          Row(
                            children: [
                              _buildCircleButton(Icons.more_horiz, () {
                                print('More');
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Movie Info Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Bookmark
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.movie?.title ?? '',
                            style: GoogleFonts.merriweather(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.white : Util.TitleColor,
                            ),
                          ),
                        ),
                        _build_BookMark_Favorite(context, isFavorite),
                      ],
                    ),

                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text(
                          '${widget.movie?.rating ?? 0}/10 IMDb',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Genres
                    Wrap(
                      spacing: 8,
                      children: [
                        ...(widget.movie?.genres.split(',') ?? []).map(
                          (e) => _buildGenreChip(e),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Movie Details
                    Row(
                      children: [
                        _buildDetailItem(
                          'Length',
                          Util.formatDuration(widget.movie?.duration ?? 0),
                        ),
                        SizedBox(width: 24),
                        _buildDetailItem('Language', 'English'),
                        SizedBox(width: 24),
                        _buildDetailItem(
                          'Rating',
                          '${widget.movie?.rating}/10' ?? '',
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Description
                    Text(
                      'Description',
                      style: GoogleFonts.merriweather(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Util.TitleColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.movie?.overview ?? '',
                      style: TextStyle(color: Colors.grey[600], height: 1.5),
                    ),
                    SizedBox(height: 24),

                    // Cast
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cast',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See more',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _parseCast(widget.movie?.movieCast).length,
                        itemBuilder: (context, index) {
                          final name =
                              _parseCast(widget.movie?.movieCast)[index];
                          return _buildCastItem(name, dark);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconButton _build_BookMark_Favorite(BuildContext context, bool isFavorite) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.bookmark_added : Icons.bookmark_border,
        color: Colors.amber,
      ),
      onPressed: () {
        if (isFavorite) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Movie Favorite Already !!!'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          DatabaseService.addToFavorite(widget.movie?.movieId ?? 0);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added to favorites'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            isFavorite = true;
          });
        }
      },
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.9),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildGenreChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCastItem(String name, bool dark) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FutureBuilder<String>(
              future: ImageService.getCast(name, widget.movie?.title ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: dark ? Colors.grey[900] : Colors.grey[300],
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: dark ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  );
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data?.isEmpty == true) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: dark ? Colors.grey[900] : Colors.grey[300],
                    child: Center(
                      child: Text(
                        name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: dark ? Colors.white70 : Colors.grey[700],
                        ),
                      ),
                    ),
                  );
                }

                return Image.network(
                  snapshot.data!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: dark ? Colors.grey[900] : Colors.grey[300],
                      child: Center(
                        child: Text(
                          name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: dark ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: dark ? Colors.white : Util.TitleColor,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
