import 'dart:async';
import 'dart:convert';
import 'package:screen_state/screen_state.dart';
import 'package:belks_tube/services/providers.dart';
import 'package:belks_tube/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:belks_tube/models/models.dart';
import 'package:android_window/main.dart' as android_window;
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'dart:io';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class VideoScreen extends ConsumerStatefulWidget {
  final Video video;
  final Channel channel;

  VideoScreen({
    required this.video,
    required this.channel,
  });

  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends ConsumerState<VideoScreen>
    with WidgetsBindingObserver {
  late YoutubePlayerController controller;

  Screen screen = Screen();
  late StreamSubscription<ScreenStateEvent> screenSubscription;
  bool screenIsOn = true;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: []); //We can turn off top system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: []);
    WidgetsBinding.instance.addObserver(this);
    controller = YoutubePlayerController(
        initialVideoId: widget.video.id,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false));
    startScreenListening();
    if (Platform.isAndroid) {
      checkAndOpenPopup();
    }
  }

  void checkAndOpenPopup() {
    Future.delayed(const Duration(milliseconds: 200), () {
      var popUpIsOpen = ref.read(openPopupProvider);

      if (popUpIsOpen) {
        android_window.close();
      }
      android_window.open(
        size: const Size(30, 30),
        position: const Offset(200, 0),
        focusable: true,
      );
      ref.read(openPopupProvider.notifier).state = true;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      setState(() {});
    }
  }

  void startScreenListening() {
    try {
      screenSubscription = screen.screenStateStream!.listen(onData);
    } on ScreenStateException catch (e) {
      debugPrint(e.toString());
    }
  }

  void onData(ScreenStateEvent event) {
    if (!ref.read(userProvider).canPlayBlackScreen) {
      switch (event) {
        case ScreenStateEvent.SCREEN_OFF:
          screenIsOn = false;
          debugPrint('!!!!!!!! Screen status ${screenIsOn.toString()}');
          break;
        case ScreenStateEvent.SCREEN_ON:
          screenIsOn = true;
          debugPrint('!!!!!!!! Screen status ${screenIsOn.toString()}');

          break;
        case ScreenStateEvent.SCREEN_UNLOCKED:
          break;
      }
    }
    debugPrint('!!!!!! SCREEN EVENT:  $event');
  }

  @override
  Widget build(BuildContext context) {
    var popUpIsOpened = ref.watch(openPopupProvider);
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    DateTime posted = DateTime.parse(widget.video.publishedAt).toLocal();
    String postedDate = DateFormat('dd/MM/yyyy HH:mm').format(posted);
    final postedAgo = DateTime.now().difference(posted);

    android_window.setHandler((name, data) async {
      switch (name) {
        case 'get params':
          var params = {
            'videoId': widget.video.id,
            'currentPosition': controller.value.position.inMilliseconds,
            'canPlayBlackScreen': ref.read(userProvider).canPlayBlackScreen
          };
          debugPrint(controller.value.toString());
          return json.encode(params);
        case 'closed':
          ref.read(openPopupProvider.notifier).state = false;
          debugPrint(
              '!!!!! CLOSED POPUP!! STATUS = ${ref.read(openPopupProvider).toString()}');
          return 'closed';
        case 'ping':
          debugPrint(data.toString());
          return 'pong';
      }
      return null;
    });

    return FGBGNotifier(
      onEvent: (FGBGType value) async {
        debugPrint('!!!!!! ScreenStatusBefore FGBG : ${screenIsOn.toString()}');
        if (Platform.isAndroid && screenIsOn) {
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
            debugPrint('!!!!!FOREGROUND!!! POPUP IS OPENED = $popUpIsOpened');
            if (popUpIsOpened) {
              android_window.post('halt');
            } else {
              debugPrint('!!!!!! OPENING POPUP !!!!!!!!!');
              android_window.open(
                size: const Size(30, 30),
                position: const Offset(200, 0),
                focusable: true,
              );
              ref.read(openPopupProvider.notifier).state = true;
            }
            var params = await android_window.post('get params');
            controller
              ..seekTo(Duration(milliseconds: int.parse(params.toString())))
              ..play();
            debugPrint('new timepoint : $params');
          }
        }
      },
      child: Scaffold(
        //using Stack here to avoid scrolling and exceeded height in fullscreen
        body: Stack(children: [
          (isPortrait)
              ? ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 16 * 9,
                    ),
                    Container(
                      color: Colors.white70,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          widget.video.title,
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 2,
                      color: Colors.black,
                    ),
                    Container(
                      color: Colors.white54,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(children: [
                          Text(
                            'Posted: $postedDate',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const Spacer(),
                          Text(
                              timeago
                                  .format(DateTime.now().subtract(postedAgo)),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText2),
                        ]),
                      ),
                    )
                  ],
                )
              : const SizedBox.shrink(),
          YoutubePlayer(
            controller: controller,
          ),
        ]),
        appBar: (isPortrait)
            ? AppBar(
                centerTitle: true,
                backgroundColor: Theme.of(context).primaryColor,
                leading: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => {
                          SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.manual,
                              overlays: SystemUiOverlay.values),
                          if (Platform.isAndroid) {android_window.close()},
                          Navigator.of(context).pop()
                        }),
                title: ListTile(
                  leading: BuildProfileImg(
                      imgUrl: widget.channel.profilePictureUrl, size: 50),
                  title: Text(
                    widget.channel.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                              color: Colors.black54,
                              offset: Offset(0, 2),
                              blurRadius: 6)
                        ]),
                  ),
                  subtitle: Text(
                    '${widget.channel.subscriberCount} subscribers',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        shadows: [
                          Shadow(
                              color: Colors.black54,
                              offset: Offset(0, 2),
                              blurRadius: 3)
                        ]),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
