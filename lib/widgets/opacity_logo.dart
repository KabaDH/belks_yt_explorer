import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:belks_tube/models/models.dart';

class OpacityLogo extends StatefulWidget {
  const OpacityLogo({Key? key, required this.video}) : super(key: key);

  final Video video;

  @override
  State<OpacityLogo> createState() => _OpacityLogoState();
}

class _OpacityLogoState extends State<OpacityLogo> {
  double _logoOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _setLogoOpacity();
  }

  //Hide logo after we have loaded the screen
  Future<void> _setLogoOpacity() async {
    double newOpacity =
        await Future.delayed(const Duration(milliseconds: 1), () {
      return 0.0;
    });
    setState(() {
      if (mounted) {
        _logoOpacity = newOpacity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Uri ytVideoUrl =
        Uri.parse('https://www.youtube.com/watch?v=${widget.video.id}');

    return AnimatedOpacity(
      duration: const Duration(seconds: 2),
      opacity: _logoOpacity,
      child: IconButton(
          onPressed: () async {
            if (await canLaunchUrl(ytVideoUrl)) {
              launchUrl(
                ytVideoUrl,
              );
            } else {
              throw 'Can`t load url';
            }
          },
          icon: Image.asset(
            'assets/youtube_social_icon_red.png',
            width: 20,
            height: 20,
          )),
    );
  }
}
