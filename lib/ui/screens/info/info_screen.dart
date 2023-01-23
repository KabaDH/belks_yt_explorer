import 'package:belks_tube/ui/screens/info/widgets/menu_element.dart';
import 'package:belks_tube/ui/shared/widgets.dart';
import 'package:belks_tube/ui/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';

import 'info_screen_c.dart';

class InfoScreen extends ConsumerWidget {
  const InfoScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // User
    var m = ref.watch(InfoScreenController.provider);
    var c = ref.read(InfoScreenController.provider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Info Screen & settings',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (Platform.isAndroid)
              ? Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
                  child: Card(
                    color: Colors.white,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Play sound when the screen is turned off ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Center(
                              child: Switch(
                                onChanged: c.setCanPlayBlackScreen,
                                value: m.canPlayBlackScreen,
                              ),
                            ),
                          ),
                        ]),
                  ),
                )
              : const SizedBox.shrink(),
          const Spacer(),
          ...c.screens
              .map(
                (key, value) => MapEntry(
                  key,
                  InfoMenuElement(
                    title: key,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => value),
                    ),
                  ),
                ),
              )
              .values
              .toList(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                const Text(
                  'App dev by ',
                  style: Styles.infoBlackTextStyle,
                ),
                const Text(
                  'KabaDH',
                  style: Styles.infoBlueTextStyle,
                ),
                const Text(
                  ' with ',
                  style: Styles.infoBlackTextStyle,
                ),
                GestureDetector(
                  onTap: c.onFlutterTap,
                  child: const Text(
                    'Flutter',
                    style: Styles.infoBlueTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Version: ${c.appVersion}+${c.appBuild}',
              style: Styles.infoBlackTextStyle,
            ),
          ),
          const SizedBox(
            height: 20.0,
          )
        ],
      ),
      floatingActionButton: floatingActionButton(context),
    );
  }
}
