import 'dart:developer';
import 'package:belks_tube/data/repo/repo.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:belks_tube/screens/home/home_screen_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenControllerNotifier extends StateNotifier<HomeScreenModel> {
  HomeScreenControllerNotifier(this._ref) : super(HomeScreenModel.defModel) {
    initChannel();
  }
  final Ref _ref;

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
    final fetchedChannel = await repo.fetchChannel(channelId: channelId);
    fetchedChannel.fold((l) => log(l.toString(), name: 'fetchChannelError'),
        (r) {
      isMainChannel ? setNewMainChannel(r) : addChannelToFavorites(r);
    });
  }

  void setIsLoading(bool v) => state = state.copyWith(isLoading: v);

  /// load def Channel
  Future<void> initMainChannel() async {
    final mainChannelId = repo.getDefChannelId();
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
