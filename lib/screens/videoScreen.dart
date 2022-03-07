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
        flags: YoutubePlayerFlags(autoPlay: false, mute: false));
  }

  @override
  Widget build(BuildContext context) {
    Orientation _deviceOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   leading: IconButton(
      //       icon: Icon(Icons.arrow_back_ios, color: Colors.white),
      //       onPressed: () => Navigator.of(context).pop()),
      // ),
      bottomSheet: _deviceOrientation == Orientation.portrait
          ? Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45))),
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => {
                        SystemChrome.setEnabledSystemUIOverlays(
                            SystemUiOverlay.values),
                        Navigator.of(context).pop()
                      }),
            )
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
