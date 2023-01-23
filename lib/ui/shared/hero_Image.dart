import 'package:flutter/material.dart';

Widget heroImage(
    {required String imgLink,
    required double width,
    required double height,
    required BoxFit fit}) {
  return Image.network(
    imgLink,
    height: height,
    width: width,
    fit: fit,
  );
}
