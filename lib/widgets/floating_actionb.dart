import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

floatingActionButton(BuildContext context) {
  return Container(
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
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: SystemUiOverlay.values),
              Navigator.of(context).pop()
            }),
  );
}
