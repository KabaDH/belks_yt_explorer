import 'package:belks_tube/screens/home/home_screen_c.dart';
import 'package:belks_tube/widgets/profile_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildSearchElements extends ConsumerWidget {
  const BuildSearchElements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // List<SearchChannel>
    final m = ref
        .watch(HomeScreenController.provider.select((v) => v.searchChannels));
    final c = ref.watch(HomeScreenController.provider.notifier);

    return AnimatedContainer(
      height: m.isEmpty ? 0 : 360.0,
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withGreen(212),
          border: const Border(bottom: BorderSide(color: Colors.black26))),
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollDetails) {
          if (scrollDetails.metrics.pixels ==
              scrollDetails.metrics.maxScrollExtent) {
            // _loadMoreSearchResults();
          }
          return false;
        },
        child: m.isEmpty
            ? const SizedBox.shrink()
            : ListView.builder(
                itemCount: m.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // setState(() {
                      // searchChannels[index].id);
                      // textSearchController.text = '';
                      // searchChannels.
                      //   _newChannelInit(clear();
                      // });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(80),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 3)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BuildProfileImg(
                            imgUrl: m[index].profilePictureUrl,
                            size: 60,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 2)
                                    ]),
                              ),
                              Text(
                                m[index].description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 12),
                              )
                            ],
                          )),
                          const SizedBox(
                            width: 7,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.black54,
                              ))
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
