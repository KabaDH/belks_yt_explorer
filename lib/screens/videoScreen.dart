import 'package:belks_tube/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String id;

  VideoScreen({required this.id});

  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _controller = YoutubePlayerController(
        initialVideoId: widget.id,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false));
  }

  @override
  Widget build(BuildContext context) {
    Orientation _deviceOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
      floatingActionButton: _deviceOrientation == Orientation.portrait
          ? floatingActionButton(context)
          : null,
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          width: double.infinity,
        ),
      ),
    );
  }
}
