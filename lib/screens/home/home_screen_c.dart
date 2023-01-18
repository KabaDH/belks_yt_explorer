import 'dart:developer';
import 'package:belks_tube/data/repo/repo.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:belks_tube/screens/home/home_screen_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenControllerNotifier extends StateNotifier<HomeScreenModel> {
  HomeScreenControllerNotifier(this._ref) : super(HomeScreenModel.defModel) {
    initChannel();
  }
  final Ref _ref;
  static const int maxResults = 8;
  String _nextPageToken = '';
  String _lastPlayListId = '';
  String _lastSearchRequest = '';
  String _nextPageTokenSearch = '';

  static final provider =
      StateNotifierProvider<HomeScreenControllerNotifier, HomeScreenModel>(
          (ref) {
    return HomeScreenControllerNotifier(ref);
  });

  Repo get repo => _ref.read(repoProvider);

  void initChannel() async {
    setIsLoading(true);
    initFavoriteChannels();
    await initMainChannel();
    setIsLoading(false);
  }

  void addChannelToFavorites(Channel channel) {
    state =
        state.copyWith(favoriteChannels: [...state.favoriteChannels, channel]);
  }

  void setNewMainChannel(Channel channel) =>
      state = state.copyWith(channel: channel);

  Future<void> fetchChannel(
      {required String channelId, bool isMainChannel = false}) async {
    // Get channel info
    final fetchedChannel = await repo.fetchChannel(channelId: channelId);
    fetchedChannel.fold((l) => log(l.toString(), name: 'fetchChannelError'),
        (rChannel) async {
      // Get Videos for channel
      debugPrint('💡Repo.fetchChannel :: uploadPlaylistId :'
          ' ${rChannel.uploadPlaylistId}');
      final videos = await repo.fetchVideosFromPlayList(
          channelId: channelId,
          maxResults: maxResults,
          pageToken: _nextPageToken);

      videos.fold(
          (l) => debugPrint(
              '💡HomeScreenControllerNotifier.fetchChannel :: videos is Left :'
              ' ${l.toString()}'), (rVideos) {
        final res = rChannel.copyWith(videos: rVideos.videos);
        _nextPageToken = rVideos.nextPageToken;
        isMainChannel ? setNewMainChannel(res) : addChannelToFavorites(res);
      });
    });
  }

  void setIsLoading(bool v) => state = state.copyWith(isLoading: v);

  /// load def Channel
  Future<void> initMainChannel() async {
    final mainChannelId = repo.getMainChannelId();
    state = state.copyWith(defChannelId: mainChannelId);
    await fetchChannel(channelId: state.defChannelId, isMainChannel: true);
  }

  /// load favorites
  void initFavoriteChannels() {
    final favoriteChannelIds = repo.getFavoriteChannelsIds();
    state = state.copyWith(favoriteChannelsIds: favoriteChannelIds);
    for (var channelId in state.favoriteChannelsIds) {
      fetchChannel(channelId: channelId);
    }
  }
}
