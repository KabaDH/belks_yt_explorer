import 'package:belks_tube/data/providers/app_config.dart';
import 'package:belks_tube/screens/home/home_screen_c.dart';
import 'package:belks_tube/screens/info_screen.dart';
import 'package:belks_tube/services/providers.dart';
import 'package:belks_tube/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:belks_tube/models/models.dart';
import 'package:belks_tube/services/api_services.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  // late final String channelId = 'UCjzHeG1KWoonmf9d5KBvSiw';
  // late List<String> favoriteChannelsID;
  // List<Channel> favoriteChannels = [];
  // late String defChannelId;
  // late SharedPreferences storage;
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //
  // late Channel _channel; //загруженный канал в текущий момент
  // bool _isLoading = true;
  // bool _needMoreVideos = false;
  // bool _favChannelsLoading = true;
  // List<SearchChannel> searchChannels = []; //отображение каналов поиска
  TextEditingController textSearchController = TextEditingController();
  // late PackageInfo packageInfo;
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
    textSearchController.dispose();
  }

  // _loadMoreVideos() async {
  //   _needMoreVideos = true;
  //   List<Video> moreVideos = await APIService.instance
  //       .fetchVideosFromPlayList(playListId: _channel.uploadPlaylistId);
  //   _channel = _channel.copyWith(videos: _channel.videos! + moreVideos);
  //   setState(() {});
  //   _needMoreVideos = false;
  // }

  _updateVideosList() async {
    debugPrint('_updateVideosList');
    // setState(() => _isLoading = true);
    // List<Video> updatedVideos = await APIService.instance
    //     .fetchVideosFromPlayList(
    //         playListId: _channel.uploadPlaylistId, resetToken: true);
    // setState(() {
    //   _channel = _channel.copyWith(videos: updatedVideos);
    //   _isLoading = false;
    // });
  }

  // _loadMoreSearchResults() async {
  //   List<SearchChannel> moreChannels = await APIService.instance
  //       .fetchSearchResults(searchRequest: textSearchController.value.text);
  //   setState(() {
  //     searchChannels.addAll(moreChannels);
  //   });
  // }

  // //Безопасная заглушка, если видео не прогрузились (или нет видео) не показываем когда вышло последнее видео
  // String _lastUpdatedVideo(int index) {
  //   try {
  //     String lastVideoTime =
  //         'Updated ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(favoriteChannels[index].videos![0].publishedAt).toLocal())}';
  //     return lastVideoTime;
  //   } catch (e) {
  //     return '';
  //   }
  // }

  //элементы drawer
  // _buildFavorites() {
  //   return Expanded(
  //     child: Container(
  //       color: Theme.of(context).primaryColor,
  //       child: favoriteChannels.isEmpty
  //           ? const SizedBox.shrink()
  //           : ListView.builder(
  //               itemCount: favoriteChannels.length,
  //               itemBuilder: (context, index) {
  //                 return GestureDetector(
  //                   onTap: () {
  //                     setState(() {
  //                       _channel = favoriteChannels[index];
  //                     });
  //                   },
  //                   child: Container(
  //                     width: double.infinity,
  //                     height: 80,
  //                     margin: const EdgeInsets.symmetric(
  //                         horizontal: 5, vertical: 5),
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: 15, vertical: 10),
  //                     decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(80),
  //                         boxShadow: const [
  //                           BoxShadow(
  //                               color: Colors.black26,
  //                               offset: Offset(0, 2),
  //                               blurRadius: 3)
  //                         ]),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         BuildProfileImg(
  //                             imgUrl: favoriteChannels[index].profilePictureUrl,
  //                             size: 60),
  //                         const SizedBox(
  //                           width: 7,
  //                         ),
  //                         Expanded(
  //                             child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               favoriteChannels[index].title,
  //                               maxLines: 1,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: const TextStyle(
  //                                   color: Colors.black,
  //                                   fontSize: 18,
  //                                   fontWeight: FontWeight.bold,
  //                                   shadows: [
  //                                     Shadow(
  //                                         color: Colors.black26,
  //                                         offset: Offset(0, 2),
  //                                         blurRadius: 2)
  //                                   ]),
  //                             ),
  //                             Text(
  //                               _lastUpdatedVideo(index),
  //                               style: TextStyle(
  //                                   color: Colors.grey[400], fontSize: 12),
  //                             )
  //                           ],
  //                         )),
  //                         const SizedBox(
  //                           width: 7,
  //                         ),
  //                         IconButton(
  //                             onPressed: () =>
  //                                 _removeDialog(favoriteChannels[index]),
  //                             icon: const Icon(
  //                               Icons.cancel,
  //                               size: 30,
  //                               color: Colors.black54,
  //                             ))
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               }),
  //     ),
  //   );
  // }

  //Button remove fav pressed
  // Future<void> _removeDialog(Channel c) async {
  //   return showDialog<void>(
  //       context: context,
  //       barrierDismissible: false, //user must tap the button
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text('Confirmation require'),
  //           content: SingleChildScrollView(
  //             child: RichText(
  //               text: TextSpan(
  //                   text: 'Remove channel ',
  //                   style: const TextStyle(color: Colors.black, fontSize: 16),
  //                   children: [
  //                     TextSpan(
  //                         text: c.title,
  //                         style: const TextStyle(
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 20)),
  //                     const TextSpan(
  //                         text: ' from list?',
  //                         style: TextStyle(color: Colors.black, fontSize: 16))
  //                   ]),
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //                 onPressed: () =>
  //                     {Navigator.of(context).pop(), _channelRemoval(c)},
  //                 child: const Text(
  //                   'Yes',
  //                   style: TextStyle(color: Colors.black),
  //                 )),
  //             TextButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: const Text(
  //                   'No',
  //                   style: TextStyle(color: Colors.black),
  //                 )),
  //           ],
  //         );
  //       });
  // }

  // Future<void> _channelRemoval(Channel c) async {
  //   List<Channel> favChannels;
  //   favChannels = favoriteChannels;
  //   SharedPreferences prefs = await _prefs;
  //
  //   if (c != _channel) {
  //     setState(() {
  //       favoriteChannels.remove(c);
  //       favoriteChannelsID.remove(c.id);
  //       prefs.setStringList('favoriteChannelsID', favoriteChannelsID);
  //     });
  //   } else {
  //     favChannels.remove(c);
  //     if (favChannels.isNotEmpty) {
  //       setState(() {
  //         _isLoading = true;
  //         favoriteChannels = favChannels;
  //         favoriteChannelsID.remove(c.id);
  //         _channel = favoriteChannels[0];
  //         prefs.setStringList('favoriteChannelsID', favoriteChannelsID);
  //         _isLoading = false;
  //       });
  //     } else {
  //       Channel tmpChannel;
  //       tmpChannel =
  //           await APIService.instance.fetchChannel(channelId: channelId);
  //
  //       setState(() {
  //         _isLoading = true;
  //
  //         prefs.remove('defChannelId');
  //         prefs.remove('favoriteChannelsID');
  //
  //         favoriteChannels.remove(c);
  //         favoriteChannelsID.remove(c.id);
  //         _channel = tmpChannel;
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  // _newChannelInit(String c) async {
  //   bool ping = await APIService.instance.pingChannel(channelId: c);
  //   String pingUserID = await APIService.instance.pingChannelUser(userID: c);
  //
  //   _newChannelAccepted(String c) async {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('New channel added successfully'),
  //       duration: Duration(seconds: 3),
  //     ));
  //
  //     if (favoriteChannelsID.contains(c)) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Can`t add - you have this channel in favorites'),
  //         duration: Duration(seconds: 3),
  //       ));
  //     } else {
  //       favoriteChannelsID.add(c);
  //       Channel newchannel =
  //           await APIService.instance.fetchChannel(channelId: c);
  //       SharedPreferences prefs = await _prefs;
  //       prefs.setString('defChannelId', c);
  //       prefs.setStringList('favoriteChannelsID', favoriteChannelsID);
  //
  //       setState(() {
  //         _channel = newchannel;
  //         favoriteChannels.add(newchannel);
  //       });
  //     }
  //   }
  //
  //   if (!ping) {
  //     if (pingUserID == 'NoSuchUser') {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('No such channel'),
  //         duration: Duration(seconds: 3),
  //       ));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Channel OK by UserID'),
  //         duration: Duration(seconds: 3),
  //       ));
  //       _newChannelAccepted(pingUserID);
  //     }
  //   } else {
  //     _newChannelAccepted(c); //Accepted by ChannelID
  //   }
  // }

  // _menuAddFavSearch() {
  //   return Container(
  //       width: MediaQuery.of(context).size.width * 0.7,
  //       padding: const EdgeInsets.all(10),
  //       decoration: BoxDecoration(
  //           color: Theme.of(context).primaryColor,
  //           borderRadius: BorderRadius.circular(10)),
  //       child: Column(
  //         children: [
  //           TextField(
  //             controller: textSearchController,
  //             onSubmitted: (newRequest) async {
  //               List<SearchChannel> _newSearchResults = await APIService
  //                   .instance
  //                   .fetchSearchResults(searchRequest: newRequest);
  //               setState(() {
  //                 searchChannels = _newSearchResults;
  //                 debugPrint(searchChannels.toString());
  //               });
  //             },
  //             decoration: const InputDecoration(
  //               hintText: 'Find more',
  //             ),
  //           ),
  //         ],
  //       ));
  // }

  // _buildSearchElements() {
  //   return AnimatedContainer(
  //     height: searchChannels.isEmpty ? 0 : 360.0,
  //     duration: const Duration(milliseconds: 500),
  //     decoration: BoxDecoration(
  //         color: Theme.of(context).primaryColor.withGreen(212),
  //         border: const Border(bottom: BorderSide(color: Colors.black26))),
  //     child: NotificationListener<ScrollEndNotification>(
  //       onNotification: (scrollDetails) {
  //         if (scrollDetails.metrics.pixels ==
  //             scrollDetails.metrics.maxScrollExtent) {
  //           _loadMoreSearchResults();
  //         }
  //         return false;
  //       },
  //       child: searchChannels.isEmpty
  //           ? const SizedBox.shrink()
  //           : ListView.builder(
  //               itemCount: searchChannels.length,
  //               itemBuilder: (context, index) {
  //                 return GestureDetector(
  //                   onTap: () {
  //                     setState(() {
  //                       _newChannelInit(searchChannels[index].id);
  //                       textSearchController.text = '';
  //                       searchChannels.clear();
  //                     });
  //                   },
  //                   child: Container(
  //                     width: double.infinity,
  //                     height: 80,
  //                     margin: const EdgeInsets.symmetric(
  //                         horizontal: 5, vertical: 5),
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: 15, vertical: 10),
  //                     decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(80),
  //                         boxShadow: const [
  //                           BoxShadow(
  //                               color: Colors.black26,
  //                               offset: Offset(0, 2),
  //                               blurRadius: 3)
  //                         ]),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         BuildProfileImg(
  //                           imgUrl: searchChannels[index].profilePictureUrl,
  //                           size: 60,
  //                         ),
  //                         const SizedBox(
  //                           width: 7,
  //                         ),
  //                         Expanded(
  //                             child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               searchChannels[index].title,
  //                               maxLines: 1,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: const TextStyle(
  //                                   color: Colors.black,
  //                                   fontSize: 18,
  //                                   fontWeight: FontWeight.bold,
  //                                   shadows: [
  //                                     Shadow(
  //                                         color: Colors.black26,
  //                                         offset: Offset(0, 2),
  //                                         blurRadius: 2)
  //                                   ]),
  //                             ),
  //                             Text(
  //                               searchChannels[index].description,
  //                               maxLines: 2,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: TextStyle(
  //                                   color: Colors.grey[400], fontSize: 12),
  //                             )
  //                           ],
  //                         )),
  //                         const SizedBox(
  //                           width: 7,
  //                         ),
  //                         IconButton(
  //                             onPressed: () {},
  //                             icon: const Icon(
  //                               Icons.add,
  //                               size: 30,
  //                               color: Colors.black54,
  //                             ))
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               }),
  //     ),
  //   );
  // }

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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => InfoScreen(
                          appBuild: AppConfig.instance.buildNumber,
                          appVersion: AppConfig.instance.version,
                        )));
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
              onRefresh: () => _updateVideosList(),
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollDetails) {
                  // if (!_needMoreVideos &&
                  //     _channel.videos!.length != _channel.videoCount &&
                  //     scrollDetails.metrics.pixels ==
                  //         scrollDetails.metrics.maxScrollExtent) {
                  //   _loadMoreVideos();
                  // }
                  return false;
                },
                child: (m.channel.videos.isEmpty)
                    ? const SizedBox.shrink()
                    : ListView.builder(
                        itemCount: m.channel.videos.length,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        itemBuilder: (context, index) {
                          Video video = m.channel.videos[index];
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
                    children: [
                      ///TODO(ivn): add model inside
                      Container(
                        width: 100,
                        height: 100,
                      ), // заглушка
                      // _menuAddFavSearch(),
                      // _buildSearchElements(),
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
                          children: [
                            ///TODO(ivn): add model inside
                            Container(
                              width: 100,
                              height: 100,
                            ), // заглушка
                            // _menuAddFavSearch(),
                            // _buildSearchElements(),
                            // _buildFavorites(),
                          ],
                        ),
                ),
              ),
            ),
    );
  }
}
