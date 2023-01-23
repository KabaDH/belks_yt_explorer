import 'dart:developer';
import 'package:belks_tube/data/providers/app_config.dart';
import 'package:belks_tube/data/repo/repo.dart';
import 'package:belks_tube/domain/channel/channel_model.dart';
import 'package:belks_tube/domain/video/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_screen_model.dart';

class HomeScreenController extends StateNotifier<HomeScreenModel> {
  HomeScreenController(this._ref) : super(HomeScreenModel.defModel) {
    init();
  }
  final Ref _ref;
  static const int _maxResults = 8;
  String? _nextPageToken;
  String lastSearchRequest = '';
  String? _nextPageTokenSearch;
  final TextEditingController textEditingController = TextEditingController();

  static final provider =
      StateNotifierProvider<HomeScreenController, HomeScreenModel>((ref) {
    return HomeScreenController(ref);
  });

  Repo get repo => _ref.read(repoProvider);

  void init() async {
    debugPrint('💡HomeScreenController.initChannel :: loading');
    setIsLoading(true);
    await initChannels();
    setFavChannelsIsLoading(false);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void addChannelToFavorites(Channel channel) {
    state =
        state.copyWith(favoriteChannels: [...state.favoriteChannels, channel]);
    repo.setFavoriteChannelsIds(state.favoriteChannelsIds);
  }

  void setNewMainChannel(Channel channel) {
    repo.setMainChannel(channel);
    state = state.copyWith(channel: channel);
    setIsLoading(false);
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

      // Reset token for new main channel
      if (channelId != state.channel.id && isMainChannel) _nextPageToken = null;

      final videos = await repo.fetchVideosFromPlayList(
          playlistId: rChannel.uploadPlaylistId,
          maxResults: _maxResults,
          pageToken: isMainChannel ? _nextPageToken : null);

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

  void loadingVideos(bool v) => state = state.copyWith(loadingVideos: v);

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
    loadingVideos(true);

    final videos = await repo.fetchVideosFromPlayList(
        playlistId: state.channel.uploadPlaylistId,
        maxResults: _maxResults,
        pageToken: _nextPageToken);

    videos.fold(
        (l) => debugPrint(
            '💡HomeScreenControllerNotifier.loadMoreVideos :: videos is Left :'
            ' ${l.failedValue}'), (rVideos) {
      addVideosToMainChannel(videos: rVideos.videos);
      _nextPageToken = rVideos.nextPageToken;
    });
    loadingVideos(false);
  }

  bool onScrollNotification(ScrollNotification scrollDetails) {
    if (!state.loadingVideos &&
        state.channel.videos.length != state.channel.videoCount &&
        (scrollDetails.metrics.pixels >
            (scrollDetails.metrics.maxScrollExtent - 200))) {
      loadMoreVideos();
    }
    return false;
  }

  Future<void> updateVideosList() async {
    setIsLoading(true);

    final videos = await repo.fetchVideosFromPlayList(
        playlistId: state.channel.uploadPlaylistId,
        maxResults: _maxResults,
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

  Future<void> fetchSearchResults(String input) async {
    if (lastSearchRequest != input) {
      state = state.copyWith(searchChannels: []);
      _nextPageTokenSearch = null;
    }
    lastSearchRequest = input;
    final moreChannels = await repo.fetchSearchResults(
        searchRequest: input, pageToken: _nextPageTokenSearch);
    moreChannels.fold(
      (l) =>
          debugPrint('💡HomeScreenControllerNotifier.loadMoreSearchResults :: '
              'SearchResults is Left :'
              ' ${l.failedValue}'),
      (rSearchChannels) {
        _nextPageTokenSearch = rSearchChannels.nextPageToken;
        state = state.copyWith(
            searchChannels: state.searchChannels + rSearchChannels.channels);
      },
    );
  }

  initNewChannel(String channelId, BuildContext context) async {
    if (state.favoriteChannelsIds.contains(channelId)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Can`t add - you have this channel in favorites'),
        duration: Duration(seconds: 3),
      ));
    } else {
      fetchChannel(channelId: channelId, isMainChannel: true);
    }
  }

  bool loadMoreSearchResults(ScrollNotification scrollDetails) {
    if (scrollDetails.metrics.pixels >
        scrollDetails.metrics.maxScrollExtent - 30) {
      fetchSearchResults(lastSearchRequest);
    }
    return false;
  }

  void onSearchChannelTap(String channelId,
      TextEditingController textController, BuildContext context) {
    initNewChannel(channelId, context);
    textController.text = '';
    state = state.copyWith(searchChannels: []);
  }
}
