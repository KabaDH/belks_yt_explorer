import 'package:flutter/cupertino.dart';

buildProfileImg(String imgUrl) {
  return ClipRRect(
    borderRadius: imgUrl.contains('yt3.ggpht.com')
        ? BorderRadius.zero
        : BorderRadius.circular(60),
    //yt3.ggpht.com is blocked in Russia
    child: imgUrl.contains('yt3.ggpht.com')
        ? Image.asset(
            'assets/na.png',
            height: 60,
            width: 60,
          )
        : Image(
            image: NetworkImage(imgUrl),
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
  );
}
