import 'package:belks_tube/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:belks_tube/models/models.dart';

class VideoScreen extends StatefulWidget {
  final Video video;

  VideoScreen({
    required this.video,
  });

  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  double _logoOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _controller = YoutubePlayerController(
        initialVideoId: widget.video.id,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false));
    _setLogoOpacity();
  }

  //Hide logo after we have loaded the screen
  Future<void> _setLogoOpacity() async {
    double newOpacity =
        await Future.delayed(const Duration(milliseconds: 1), () {
      return 0.0;
    });
    setState(() {
      _logoOpacity = newOpacity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Uri ytVideoUrl =
        Uri.parse('https://www.youtube.com/watch?v=${widget.video.id}');

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
                child: AnimatedOpacity(
                  duration: const Duration(seconds: 3),
                  opacity: _logoOpacity,
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
                  ),
                )),
          ),
        ]),
      ),
    );
  }
}
