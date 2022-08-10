import 'dart:convert';

import 'package:belks_tube/services/providers.dart';
import 'package:belks_tube/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:belks_tube/models/models.dart';
import 'package:android_window/main.dart' as android_window;
import 'package:flutter_fgbg/flutter_fgbg.dart';

class VideoScreen extends ConsumerStatefulWidget {
  final Video video;

  VideoScreen({
    required this.video,
  });

  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends ConsumerState<VideoScreen>
    with WidgetsBindingObserver {
  late YoutubePlayerController controller;
  // double logoOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    WidgetsBinding.instance.addObserver(this);
    controller = YoutubePlayerController(
        initialVideoId: widget.video.id,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false));
    // setLogoOpacity();
    checkAndOpenPopup();
  }

  // Hide logo after we have loaded the screen
  // Future<void> setLogoOpacity() async {
  //   double newOpacity =
  //       await Future.delayed(const Duration(milliseconds: 1), () {
  //     return 0.0;
  //   });
  //   setState(() {
  //     if (mounted) {
  //       logoOpacity = newOpacity;
  //     }
  //   });
  // }

  void checkAndOpenPopup() {
    Future.delayed(const Duration(milliseconds: 200), () {
      var popUpIsOpen = ref.read(openPopupProvider);

      if (popUpIsOpen) {
        android_window.close();
      }
      android_window.open(
        size: const Size(500, 280),
        position: const Offset(0, 0),
        focusable: true,
      );
      ref.read(openPopupProvider.notifier).state = true;
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uri ytVideoUrl =
        Uri.parse('https://www.youtube.com/watch?v=${widget.video.id}');

    android_window.setHandler((name, data) async {
      switch (name) {
        case 'hello':
          showSnackBar(context, 'message from android window: $data');
          return 'hello android window';

        case 'get params':
          var params = {
            'videoId': widget.video.id,
            'currentPosition': controller.value.position.inMilliseconds,
          };
          debugPrint(controller.value.toString());
          return json.encode(params);
        case 'ping':
          debugPrint(data.toString());
          return 'pong';
      }
      return null;
    });

    Orientation _deviceOrientation = MediaQuery.of(context).orientation;
    return FGBGNotifier(
      onEvent: (FGBGType value) async {
        if (value == FGBGType.background) {
          var params = {
            'videoId': widget.video.id,
            'currentPosition': controller.value.position.inMilliseconds,
          };
          var resp =
              await android_window.post('new params', json.encode(params));
          debugPrint(resp.toString());
        }

        if (value == FGBGType.foreground) {
          android_window.post('halt');
          var params = await android_window.post('get params');
          controller
            ..seekTo(Duration(milliseconds: int.parse(params.toString())))
            ..play();
          debugPrint('new timepoint : $params');
        }
      },
      child: Scaffold(
        body: ListView(children: [
          Stack(children: [
            YoutubePlayer(
              controller: controller,
              width: double.infinity,
            ),
            // Visibility(
            //   visible: _deviceOrientation == Orientation.portrait,
            //   child: Positioned(
            //       left: 10,
            //       bottom: 10,
            //       child: AnimatedOpacity(
            //         duration: const Duration(seconds: 3),
            //         opacity: logoOpacity,
            //         child: GestureDetector(
            //           child: Image.asset(
            //             'assets/yt_logo_rgb_dark.png',
            //             width: 100,
            //             fit: BoxFit.cover,
            //           ),
            //           onTap: () async {
            //             if (await canLaunchUrl(ytVideoUrl)) {
            //               launchUrl(
            //                 ytVideoUrl,
            //               );
            //             } else {
            //               throw 'Can`t load url';
            //             }
            //           },
            //         ),
            //       )),
            // ),
          ]),
          ElevatedButton(
            onPressed: () async {
              showSnackBar(
                  context, '${await android_window.canDrawOverlays()}');
            },
            child: const Text('Check can draw overlays'),
          ),
          const ElevatedButton(
            onPressed: android_window.requestPermission,
            child: Text('Request overlay display permission'),
          ),
          ElevatedButton(
            onPressed: () => android_window.open(
              size: const Size(500, 280),
              position: const Offset(0, 0),
              focusable: true,
            ),
            child: const Text('Open android window'),
          ),
          const ElevatedButton(
            onPressed: android_window.close,
            child: Text('Close android window'),
          ),
          ElevatedButton(
            onPressed: () =>
                debugPrint(controller.value.position.inMilliseconds.toString()),
            child: const Text('view controller value'),
          ),
          ElevatedButton(
            onPressed: () async {
              final response = await android_window.post(
                'hello',
                'hello android window',
              );
              showSnackBar(context, 'response from android window: $response');
            },
            child: const Text('Send message to android window'),
          ),
        ]),
        floatingActionButton: _deviceOrientation == Orientation.portrait
            ? SafeArea(
              child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  padding: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  width: 60,
                  height: 60,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => {
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.manual,
                                overlays: SystemUiOverlay.values),
                            android_window.close(),
                            Navigator.of(context).pop()
                          }),
                ),
            )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }

  showSnackBar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
  }
}
