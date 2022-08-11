import 'dart:async';
import 'dart:convert';
import 'package:android_window/android_window.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class AndroidWindowApp extends StatelessWidget {
  const AndroidWindowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PopUpWindow(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PopUpWindow extends StatefulWidget {
  const PopUpWindow({Key? key}) : super(key: key);

  @override
  State<PopUpWindow> createState() => _PopUpWindowState();
}

class _PopUpWindowState extends State<PopUpWindow> {
  String videoId = 'o6ekNtTu75Y';
  late final PodPlayerController _controller;
  bool isLoading = true;
  bool halted = true;
  bool transparentButtons = true;

  @override
  void initState() {
    super.initState();
    loadVideo();
    pingPong();
  }

  void pingPong() async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      var pong = await AndroidWindow.post('ping', 'ping');
      debugPrint(pong.toString());
    });
  }

  void loadVideo() async {
    var newParams = await AndroidWindow.post('get params');
    var params = jsonDecode(newParams.toString());
    final urls = await PodPlayerController.getYoutubeUrls(
      'https://youtu.be/${params['videoId']}',
    );

    _controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.networkQualityUrls(videoUrls: urls!),
      podPlayerConfig: const PodPlayerConfig(
        autoPlay: false,
        videoQualityPriority: [360, 240, 720, 1080],
      ),
    )
      ..initialise()
      ..videoSeekTo(Duration(milliseconds: params['currentPosition']));
    setState(() => {
          isLoading = false,
          videoId = params['videoId'],
        });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _haltPopUp() {
    _controller.mute();
    _controller.pause();
    AndroidWindow.setPosition(200, 0);
    AndroidWindow.resize(30, 30); //500, 280 = 30,30
    setState(() {
      halted = true;
    });
    debugPrint('Halted = ${halted.toString()}');
  }

  void _unHaltPopup() {
    _controller.unMute();
    _controller.play();
    AndroidWindow.setPosition(0, 0);
    AndroidWindow.resize(500, 280); //500, 280 = 30,30
    setState(() {
      halted = false;
    });
    debugPrint('Halted = ${halted.toString()}');
  }

  // Hide btns after we have loaded the screen
  // Future<void> setOpacity(Duration lag) async {
  //   bool newOpacity = await Future.delayed(lag, () {
  //     return !transparentButtons;
  //   });
  //   setState(() {
  //     if (mounted) {
  //       transparentButtons = newOpacity;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    AndroidWindow.setHandler((name, data) async {
      switch (name) {
        case 'get params':
          return _controller.currentVideoPosition.inMilliseconds;
        case 'new params':
          var params = jsonDecode(data.toString());
          var newVideoId = params['videoId'];
          var newVideoPosition = params['currentPosition'];
          debugPrint('!!!!! NEW PARAMS $newVideoId and $newVideoPosition');
          if (newVideoId == videoId) {
            _controller
              ..videoSeekTo(Duration(milliseconds: newVideoPosition))
              ..play();
            _unHaltPopup();

            return 'new position $newVideoPosition done';
          } else {
            try {
              final urls = await PodPlayerController.getYoutubeUrls(
                'https://youtu.be/$newVideoId',
              );
              _controller
                ..changeVideo(
                  playVideoFrom:
                      PlayVideoFrom.networkQualityUrls(videoUrls: urls!),
                  playerConfig: const PodPlayerConfig(
                    autoPlay: true,
                    videoQualityPriority: [360, 240, 720, 1080],
                  ),
                )
                ..videoSeekTo(Duration(
                    milliseconds: int.parse(params['currentPosition'])))
                ..unMute()
                ..play();
              _unHaltPopup();
              return "new video started";
            } catch (e) {
              return e.toString();
            }
          }

        case 'halt':
          try {
            _haltPopUp();
            return "halted";
          } catch (e) {
            return e.toString();
          }
        case 'unhalt':
          try {
            _unHaltPopup();
            return "Unhalted";
          } catch (e) {
            return e.toString();
          }
        case 'close':
          try {
            AndroidWindow.close();
            return "closed";
          } catch (e) {
            return e.toString();
          }
        case 'setNewVideo':
          try {
            var params = jsonDecode(data.toString());
            final urls = await PodPlayerController.getYoutubeUrls(
              'https://youtu.be/${params['videoId']}',
            );
            debugPrint('PARAMS!!!!!!!!!!!!!!!! = ${params.toString()}');
            _controller
              ..changeVideo(
                playVideoFrom:
                    PlayVideoFrom.networkQualityUrls(videoUrls: urls!),
                playerConfig: const PodPlayerConfig(
                  autoPlay: true,
                  videoQualityPriority: [360, 240, 720, 1080],
                ),
              )
              ..videoSeekTo(
                  Duration(milliseconds: int.parse(params['currentPosition'])))
              ..unMute();

            AndroidWindow.setPosition(0, 0);

            return "new video started";
          } catch (e) {
            return e.toString();
          }
      }
      return null;
    });

    return AndroidWindow(
      child: Opacity(
        opacity: (halted) ? 0.0 : 1.0,
        child: IgnorePointer(
          ignoring: halted,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(alignment: Alignment.bottomLeft, children: [
              Container(
                color: Colors.transparent,
              ),
              ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: (halted)
                    ? BorderRadius.zero
                    : const BorderRadius.all(Radius.circular(8)),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AspectRatio(
                        aspectRatio: 16 / 9,
                        child: PodVideoPlayer(
                          controller: _controller,
                          alwaysShowProgressBar: false,
                          backgroundColor: Colors.transparent,
                        )),
              ),
              const ModalBarrier(),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      transparentButtons = !transparentButtons;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                  )),
              (halted)
                  ? const SizedBox.shrink()
                  : Positioned(
                      right: 0,
                      top: 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: (transparentButtons) ? 0.0 : 1.0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            size: 25,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            AndroidWindow.post('closed');
                            AndroidWindow.close();
                          },
                        ),
                      )),
              (halted)
                  ? const SizedBox.shrink()
                  : Positioned(
                      left: 0,
                      top: 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: (transparentButtons) ? 0.0 : 1.0,
                        child: const IconButton(
                          icon: Icon(
                            Icons.fullscreen_exit_outlined,
                            size: 25,
                            color: Colors.black54,
                          ),
                          onPressed: AndroidWindow.launchApp,
                        ),
                      )),
            ]),
          ),
        ),
      ),
    );
  }
}
