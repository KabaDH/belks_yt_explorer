import 'package:belks_tube/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoScreen extends StatefulWidget {
  final String id;

  VideoScreen({
    required this.id,
  });

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
    final Uri ytVideoUrl =
        Uri.parse('https://www.youtube.com/watch?v=${widget.id}');

    Orientation _deviceOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
      floatingActionButton: _deviceOrientation == Orientation.portrait
          ? floatingActionButton(context)
          : null,
      body: Center(
        child: Stack(children: [
          YoutubePlayer(
            controller: _controller,
            width: double.infinity,
          ),
          Visibility(
            visible: _deviceOrientation == Orientation.portrait,
            child: Positioned(
                left: 10,
                bottom: 10,
                child: GestureDetector(
                  child: Image.asset(
                    'assets/yt_logo_rgb_dark.png',
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  onTap: () async {
                    if (await canLaunchUrl(ytVideoUrl)) {
                      launchUrl(
                        ytVideoUrl,
                      );
                    } else {
                      throw 'Can`t load url';
                    }
                  },
                )),
          ),

        ]),
      ),
    );
  }
}
