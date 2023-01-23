import 'package:belks_tube/services/providers.dart';
import 'package:belks_tube/ui/screens/privacy_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../shared/widgets.dart';
import 'terms_screen.dart';

class InfoScreen extends ConsumerStatefulWidget {
  const InfoScreen({
    Key? key,
    required this.appVersion,
    required this.appBuild,
  }) : super(key: key);

  final String appVersion;
  final String appBuild;

  @override
  ConsumerState<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  final double fontSize = 14.0;

  final Map<String, Widget> screens = {
    'Privacy Policy': PrivacyScreen(acceptedPrivacy: true),
    'Terms of Use': TermsOfUse(), // Terms of Use
    // About
  };

  final Uri flutterUri = Uri.parse('https://flutter.dev');


  menuElement(String title, void Function() onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 1), blurRadius: 1)
            ],
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);

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
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (Platform.isAndroid) ? Padding(
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
                            onChanged: (bool value) {
                              ref
                                  .read(userProvider.notifier)
                                  .copyWith(canPlayBlackScreen: value);
                            },
                            value: user.canPlayBlackScreen,
                          ),
                        ),
                      ),
                    ]),
              ),
            ) : const SizedBox.shrink(),
            const Spacer(),
            ...screens
                .map((key, value) => MapEntry(
                    key,
                    menuElement(
                        key,
                        () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) => value)))))
                .values
                .toList(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Text(
                    'App dev by ',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    'KabaDH',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.blue,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    ' with ',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'Flutter',
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () async {
                      if (await canLaunchUrl(flutterUri)) {
                        launchUrl(
                          flutterUri,
                        );
                      } else {
                        throw 'Can`t load url';
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Version: ${widget.appVersion}+${widget.appBuild}',
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
      floatingActionButton: floatingActionButton(context),
    );
  }
}
