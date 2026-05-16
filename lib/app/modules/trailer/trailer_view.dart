import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerView extends StatefulWidget {
  const TrailerView({super.key});

  @override
  State<TrailerView> createState() => _TrailerViewState();
}

class _TrailerViewState extends State<TrailerView> {
  late YoutubePlayerController _ytController;
  bool _isValidUrl = false;

  @override
  void initState() {
    super.initState();
    final String url = Get.arguments ?? '';
    final videoId = YoutubePlayer.convertUrlToId(url);

    if (videoId != null) {
      _isValidUrl = true;
      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: true),
      );
    }
  }

  @override
  void dispose() {
    if (_isValidUrl) _ytController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Trailer'),
      ),
      body: Center(
        child: _isValidUrl
            ? YoutubePlayer(
                controller: _ytController,
                showVideoProgressIndicator: true,
                progressIndicatorColor: const Color(0xFFFBE488),
              )
            : const Text(
                'URL trailer tidak valid atau tidak tersedia.',
                style: TextStyle(color: Colors.white70),
              ),
      ),
    );
  }
}
