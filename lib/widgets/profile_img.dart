import 'package:flutter/material.dart';

class BuildProfileImg extends StatelessWidget {
  //yt3.ggpht.com is blocked in Russia
  final String imgUrl;
  final double size;
  BuildProfileImg({Key? key, required this.imgUrl, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget showImg = Image(
      image: NetworkImage(imgUrl),
      errorBuilder: (_, __, ___) {
        return Image.asset(
          'assets/naRound.png',
          height: size,
          width: size,
        );
      },
      height: size,
      width: size,
      fit: BoxFit.cover,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: showImg,
    );
  }
}
