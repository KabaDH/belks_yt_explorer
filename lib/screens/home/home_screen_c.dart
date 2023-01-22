import 'dart:developer';
import 'package:belks_tube/data/providers/app_config.dart';
import 'package:belks_tube/data/repo/repo.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:belks_tube/models/search_model.dart';
import 'package:belks_tube/models/video_model.dart';
import 'package:belks_tube/models/videos_model.dart';
import 'package:belks_tube/screens/home/home_screen_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenController extends StateNotifier<HomeScreenModel> {
  HomeScreenController(this._ref) : super(HomeScreenModel.defModel) {
    init();
  }
  final Ref _ref;
  static const int maxResults = 8;
  String? _nextPageToken;
  String _lastPlayListId = '';
  String _lastSearchRequest = '';
  String _nextPageTokenSearch = '';

  static final provider =
      StateNotifierProvider<HomeScreenController, HomeScreenModel>((ref) {
    return HomeScreenController(ref);
  });

  Repo get repo => _ref.read(repoProvider);

  void init() async {
    debugPrint('💡HomeScreenController.initChannel :: loading');
    setIsLoading(true);
    await initChannels();
    setIsLoading(false);
    setFavChannelsIsLoading(false);
  }

  void addChannelToFavorites(Channel channel) {
    state =
        state.copyWith(favoriteChannels: [...state.favoriteChannels, channel]);
    repo.setFavoriteChannelsIds(state.favoriteChannelsIds);
  }

  void setNewMainChannel(Channel channel) {
    repo.setMainChannel(channel);
    state = state.copyWith(channel: channel);
  }

  Future<void> fetchChannel(
      {required String channelId, bool isMainChannel = false}) async {
    // Get channel info
    final fetchedChannel = await repo.fetchChannel(channelId: channelId);
    fetchedChannel
        .fold((l) => log(l.failedValue.toString(), name: 'fetchChannelError'),
            (rChannel) async {
      // Get Videos for channel
      debugPrint('💡Repo.fetchedChannel :: uploadPlaylistId :'
          ' ${rChannel.uploadPlaylistId}');

      final videos = await repo.fetchVideosFromPlayList(
          playlistId: rChannel.uploadPlaylistId,
          maxResults: maxResults,
          pageToken: _nextPageToken);

      videos.fold(
          (l) => debugPrint(
              '💡HomeScreenControllerNotifier.fetchChannel :: videos is Left :'
              ' ${l.failedValue}'), (rVideos) {
        final res = rChannel.copyWith(videos: rVideos.videos);
        _nextPageToken = rVideos.nextPageToken;
        isMainChannel
            ? {setNewMainChannel(res), addChannelToFavorites(res)}
            : addChannelToFavorites(res);
      });
    });
  }

  void setIsLoading(bool v) => state = state.copyWith(isLoading: v);

  void setFavChannelsIsLoading(bool v) =>
      state = state.copyWith(favChannelsLoading: v);

  Future<void> initChannels() async {
    final favoriteChannelIds = repo.getFavoriteChannelsIds();
    final mainChannelId = repo.getMainChannelId();

    state = state.copyWith(
        defChannelId: mainChannelId, favoriteChannelsIds: favoriteChannelIds);

    // 1 - load main channel
    fetchChannel(channelId: mainChannelId, isMainChannel: true);

    // 2 - load the rest of channels
    for (final channelId
        in state.favoriteChannelsIds.where((e) => e != mainChannelId)) {
      fetchChannel(
          channelId: channelId, isMainChannel: channelId == mainChannelId);
    }
  }

  Future<void> removeChannel(Channel c) async {
    var favChannels = state.favoriteChannels.toList();
    var favChannelsIds = state.favoriteChannelsIds.toList();

    favChannels.remove(c);
    favChannelsIds.remove(c.id);
    repo.setFavoriteChannelsIds(favChannelsIds);

    state = state.copyWith(
      favoriteChannels: favChannels,
      favoriteChannelsIds: favChannelsIds,
    );

    if (c.id == state.channel.id) {
      if (favChannels.isNotEmpty) {
        setNewMainChannel(favChannels[0]);
      } else {
        setIsLoading(true);
        await fetchChannel(
            channelId: AppConfig.defChannel, isMainChannel: true);
        setIsLoading(false);
      }
    }
  }

  void setNeedMoreVideos(bool v) => state = state.copyWith(loadingVideos: v);

  void addVideosToMainChannel(
      {required List<Video> videos, bool keepOldVideos = true}) {
    final channel = state.channel;
    state = state.copyWith(
      channel: channel.copyWith(
        videos: [
          if (keepOldVideos) ...channel.videos,
          ...videos,
        ],
      ),
    );
  }

  Future<void> loadMoreVideos() async {
    setNeedMoreVideos(true);

    final videos = await repo.fetchVideosFromPlayList(
        playlistId: state.channel.uploadPlaylistId,
        maxResults: maxResults,
        pageToken: _nextPageToken);

    videos.fold(
        (l) => debugPrint(
            '💡HomeScreenControllerNotifier.loadMoreVideos :: videos is Left :'
            ' ${l.failedValue}'), (rVideos) {
      addVideosToMainChannel(videos: rVideos.videos);
      _nextPageToken = rVideos.nextPageToken;
    });
    setNeedMoreVideos(false);
  }

  bool onScrollNotification(ScrollNotification scrollDetails) {
    if (!state.loadingVideos &&
        state.channel.videos.length != state.channel.videoCount &&
        (scrollDetails.metrics.pixels <
            (scrollDetails.metrics.maxScrollExtent - 200))) {
      loadMoreVideos();
    }
    return false;
  }

  Future<void> updateVideosList() async {
    setIsLoading(true);

    final videos = await repo.fetchVideosFromPlayList(
        playlistId: state.channel.uploadPlaylistId,
        maxResults: maxResults,
        pageToken: null);

    videos.fold(
        (l) => debugPrint(
            '💡HomeScreenControllerNotifier.updateVideosList :: videos is Left :'
            ' ${l.failedValue}'), (rVideos) {
      addVideosToMainChannel(videos: rVideos.videos, keepOldVideos: false);
      _nextPageToken = rVideos.nextPageToken;
    });
    setIsLoading(false);
  }

  Future<void> loadMoreSearchResults(String input) async {
    final moreChannels = await repo.fetchSearchResults(searchRequest: input);
    moreChannels.fold(
        (l) => debugPrint(
            '💡HomeScreenControllerNotifier.loadMoreSearchResults :: SearchResults is Left :'
            ' ${l.failedValue}'),
        (rSearchChannels) =>
            state = state.copyWith(searchChannels: rSearchChannels));
  }

  Future<void> newChannelInit(String request, BuildContext context) async {
    // final ping = await repo.pingChannel(channel: request);
    // final pingUserID = await repo.pingChannelUserName(userName: request);
    //
    // _newChannelAccepted(String c) async {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('New channel added successfully'),
    //     duration: Duration(seconds: 3),
    //   ));
    //
    //   if (favoriteChannelsID.contains(c)) {
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text('Can`t add - you have this channel in favorites'),
    //       duration: Duration(seconds: 3),
    //     ));
    //   } else {
    //     favoriteChannelsID.add(c);
    //     Channel newchannel =
    //         await APIService.instance.fetchChannel(channelId: c);
    //     SharedPreferences prefs = await _prefs;
    //     prefs.setString('defChannelId', c);
    //     prefs.setStringList('favoriteChannelsID', favoriteChannelsID);
    //
    //     setState(() {
    //       _channel = newchannel;
    //       favoriteChannels.add(newchannel);
    //     });
    //   }
    // }
    //
    // if (!ping) {
    //   if (pingUserID == 'NoSuchUser') {
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text('No such channel'),
    //       duration: Duration(seconds: 3),
    //     ));
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text('Channel OK by UserID'),
    //       duration: Duration(seconds: 3),
    //     ));
    //     _newChannelAccepted(pingUserID);
    //   }
    // } else {
    //   _newChannelAccepted(c); //Accepted by ChannelID
    // }
  }
}
