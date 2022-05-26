import 'package:flutter/material.dart';

paragraf(String text) {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    sliver: SliverToBoxAdapter(
      child: Text(
        '$text\n',
        textAlign: TextAlign.justify,
        style: const TextStyle(
            fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w300),
      ),
    ),
  );
}

header(String text) {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    sliver: SliverToBoxAdapter(
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
