import 'package:belks_tube/domain/video/video_model.dart';
import 'package:belks_tube/ui/screens/home/home_screen_c.dart';
import 'package:belks_tube/ui/screens/info/info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:belks_tube/ui/shared/widgets.dart';
import 'widgets/build_favorites.dart';
import 'widgets/build_search_elems.dart';
import 'widgets/search_and_add_fav.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
            vsync: this, duration: const Duration(seconds: 2))
          ..repeat()
        // ..addListener(() { // Не требуется, т.к. AnimatedWidget
        //   setState(() {}); // перерисовывается сам, а других элементов, зависящих
        // })                 // от контроллера у нас нет
        ;
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = ref.watch(HomeScreenController.provider); // model
    final c = ref.read(HomeScreenController.provider.notifier); // controller

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const InfoScreen()));
              },
              icon: const Icon(Icons.settings))
        ],
        title: m.isLoading
            ? const Text(
                'Belk`s Tube channel explorer',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            : ListTile(
                leading: BuildProfileImg(
                    imgUrl: m.channel.profilePictureUrl, size: 50),
                title: Text(
                  m.channel.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                            color: Colors.black54,
                            offset: Offset(0, 2),
                            blurRadius: 6)
                      ]),
                ),
                subtitle: Text(
                  '${m.channel.subscriberCount} subscribers',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      shadows: [
                        Shadow(
                            color: Colors.black54,
                            offset: Offset(0, 2),
                            blurRadius: 3)
                      ]),
                ),
                // tileColor: Colors.red,
              ),
      ),
      body: m.isLoading
          ? Center(
              child: ShowBelksProgressIndicator(
              animationController: animationController
                ..reset()
                ..forward()
                ..repeat(),
            ))
          : RefreshIndicator(
              onRefresh: c.updateVideosList,
              child: NotificationListener<ScrollNotification>(
                onNotification: c.onScrollNotification,
                child: (m.channel.videos.isEmpty)
                    ? const SizedBox.shrink()
                    : ListView.builder(
                        itemCount: m.channel.videos.length,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        itemBuilder: (context, index) {
                          Video video = m.channel.videos[index];

                          ///TODO: use select + add loading indicator to the end
                          return VideosBuilder(
                            video: video,
                            channel: m.channel,
                          );
                        }),
              ),
            ),
      drawer: m.favoriteChannels.isEmpty
          ? GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.63,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      SearchAndAddFavorite(),
                      BuildSearchElements()
                    ],
                  ),
                ),
              ),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.835,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: m.favChannelsLoading
                      ? Center(
                          child: ShowBelksProgressIndicator(
                          animationController: animationController
                            ..reset()
                            ..forward()
                            ..repeat(),
                        ))
                      : Column(
                          children: const [
                            SearchAndAddFavorite(),
                            BuildSearchElements(),
                            BuildFavorites(),
                          ],
                        ),
                ),
              ),
            ),
    );
  }
}
