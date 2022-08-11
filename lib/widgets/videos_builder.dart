import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:belks_tube/models/models.dart';
import 'package:belks_tube/screens/screens.dart';
import 'widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

///Build Video cards for HomeScreen

class VideosBuilder extends StatelessWidget {
  const VideosBuilder({Key? key, required this.video, required this.channel})
      : super(key: key);

  final Video video;
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    DateTime posted = DateTime.parse(video.publishedAt).toLocal();
    String postedDate = DateFormat('dd/MM/yyyy HH:mm').format(posted);
    final postedAgo = DateTime.now().difference(posted);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoScreen(
                  video: video,
                  channel: channel,
                )));
      },
      child: Card(
        child: SizedBox(
          height: 140,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Stack(children: [
                    heroImage(
                        imgLink: video.thumbnailUrl,
                        width: 170,
                        height: 130,
                        fit: BoxFit.cover),
                    Positioned(
                        left: 0,
                        bottom: -10.0,
                        child: OpacityLogo(video: video))
                  ]),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Text(
                        postedDate,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      Text(
                        timeago.format(DateTime.now().subtract(postedAgo)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
