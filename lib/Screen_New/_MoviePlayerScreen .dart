import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:movieappprj/Models/Episode%20.dart';

class MoviePlayerScreen extends StatefulWidget {
  final List<Episode> episodes;
  final int initialEpisodeIndex;

  const MoviePlayerScreen({
    super.key,
    required this.episodes,
    this.initialEpisodeIndex = 0,
  });

  @override
  State<MoviePlayerScreen> createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  late BetterPlayerController _betterPlayerController;
  late int _currentEpisodeIndex;

  @override
  void initState() {
    super.initState();
    _currentEpisodeIndex = widget.initialEpisodeIndex;
    _setupPlayer(widget.episodes[_currentEpisodeIndex].videoUrl);
  }

  void _setupPlayer(String url) {
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableProgressBarDrag: true,
        ),
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        url,
      ),
    );
  }

  void _changeEpisode(int index) {
    setState(() {
      _currentEpisodeIndex = index;
      _betterPlayerController.dispose();
      _setupPlayer(widget.episodes[index].videoUrl);
    });
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentEpisode = widget.episodes[_currentEpisodeIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Xem: ${currentEpisode.title}")),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: widget.episodes.length,
              itemBuilder: (context, index) {
                final episode = widget.episodes[index];
                return ListTile(
                  title: Text("Tập ${index + 1}: ${episode.title}"),
                  selected: index == _currentEpisodeIndex,
                  onTap: () => _changeEpisode(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
