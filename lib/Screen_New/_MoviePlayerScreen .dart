import 'dart:async';

import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:movieappprj/Models/User.dart';
import 'package:movieappprj/Models/ViewingHistory.dart';
import 'package:movieappprj/Services/VIewingHistoryREPO.dart';
import 'package:movieappprj/Services/ImageService.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movieappprj/Services/Global.dart';

class MoviePlayerScreen extends StatefulWidget {
  const MoviePlayerScreen({super.key});

  @override
  State<MoviePlayerScreen> createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  List<ViewingHistory> _viewingHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadViewingHistory();
  }

  Future<void> _loadViewingHistory() async {
    final history = ViewingHistoryService.getAllHistory();
    setState(() {
      _viewingHistory =
          history..sort((a, b) => b.lastWatched!.compareTo(a.lastWatched!));
      _isLoading = false;
    });
  }

  Future<Map<String, dynamic>?> _fetchMovieInfo(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movies/get/$movieId'),
        headers: {'Authorization': 'Bearer ${User.getAccessToken()}'},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error fetching movie info: $e');
    }
    return null;
  }

  void _showPlayerDialog(int movieId, int position) async {
    final info = await _fetchMovieInfo(movieId);
    print(info);
    if (info == null || info['videoUrl'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không lấy được thông tin phim hoặc video!')),
      );
      return;
    }

    final videoUrl = await ImageService.getAssets(info['videoUrl'], "video");

    final startAt = Duration(seconds: position);
    final controller = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        looping: false,
        startAt: startAt,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'Lỗi phát video: $errorMessage',
              style: TextStyle(color: Colors.white),
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
    Timer? progressTimer;
    progressTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      final ctrl = controller.videoPlayerController;
      if (ctrl?.value.isPlaying ?? false) {
        final pos = ctrl?.value.position.inSeconds ?? 0;
        final dur = ctrl?.value.duration?.inSeconds ?? 0;
        if (dur > 0) {
          final prog = (pos / dur) * 100;
          final history = ViewingHistory(
            userId: User.getUserId(),
            videoId: movieId,
            progress: prog,
            position: pos,
            lastWatched: DateTime.now(),
            isSynced: false,
          );
          await ViewingHistoryService.saveHistory(history);
        }
      }
    });
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            progressTimer?.cancel();
            controller.dispose();
            return true;
          },
          child: AlertDialog(
            backgroundColor: Colors.black,
            contentPadding: EdgeInsets.zero,
            content: AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: controller),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  progressTimer?.cancel();
                  controller.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Continue Watching",
          style: GoogleFonts.merriweather(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadViewingHistory),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Now Showing',
              style: GoogleFonts.merriweather(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    _viewingHistory.map((history) {
                      return FutureBuilder<Map<String, dynamic>?>(
                        future: _fetchMovieInfo(history.videoId),
                        builder: (context, snapshot) {
                          final info = snapshot.data;
                          final posterUrl = info?['imageUrl'] ?? '';
                          final title = info?['title'] ?? 'Unknown';
                          final rating =
                              info?['rating']?.toStringAsFixed(1) ?? '--';
                          return Container(
                            width: 140,
                            margin: EdgeInsets.only(right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap:
                                      () => _showPlayerDialog(
                                        history.videoId,
                                        history.position,
                                      ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: FutureBuilder<String>(
                                      future: ImageService.getAssets(
                                        posterUrl,
                                        "poster",
                                      ),
                                      builder: (context, imgSnapshot) {
                                        if (imgSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            width: 140,
                                            height: 200,
                                            color: Colors.grey[300],
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        }
                                        if (imgSnapshot.hasError ||
                                            !imgSnapshot.hasData ||
                                            imgSnapshot.data!.isEmpty) {
                                          return Container(
                                            width: 140,
                                            height: 200,
                                            color: Colors.grey[300],
                                            child: Icon(Icons.movie, size: 40),
                                          );
                                        }
                                        return Image.network(
                                          imgSnapshot.data!,
                                          width: 140,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      rating,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: history.progress / 100,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Đã xem ${history.progress.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
