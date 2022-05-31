import 'package:belks_tube/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/styles.dart';

class TermsOfUse extends StatelessWidget {
  TermsOfUse({Key? key}) : super(key: key);

  final Uri youtubeTermsOfServiceUri =
      Uri.parse('https://www.youtube.com/t/terms');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: floatingActionButton(context),
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 50.0,
              ),
            ),
            header('Terms of Use\n'),
            paragraf('Last updated: May 31, 2022\n'),
            paragraf(
                'We built the Belk`s Tube app as a Free application. We provide this Service at no cost and is intended for use as is.'),
            paragraf(
                'Using Belk`s Tube app, you are agreeing to be bound by the YouTube Terms of Service'),
            const SliverToBoxAdapter(
              child: Divider(
                height: 8.0,
                thickness: 4.0,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              sliver: SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () async {
                    if (await canLaunchUrl(youtubeTermsOfServiceUri)) {
                      launchUrl(
                        youtubeTermsOfServiceUri,
                      );
                    } else {
                      throw 'Can`t load url';
                    }
                  },
                  child: const Text(
                    'Go to the YouTube Terms of Service page',
                    style: Styles.hyperLinkStyle,
                  ),
                ),
              ),
            ),

          ],
        ));
  }
}
