import 'package:belks_tube/data/providers/app_config.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:belks_tube/models/search_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_screen_model.freezed.dart';

@freezed
class HomeScreenModel with _$HomeScreenModel {
  const HomeScreenModel._();

  const factory HomeScreenModel(
      {required String channelId,
      required List<Channel> favoriteChannels,
      required List<String> favoriteChannelsIds,
      required String defChannelId,
      required Channel channel,
      required bool isLoading,
      required bool needMoreVideos,
      required List<SearchChannel> searchChannels}) = _HomeScreenModel;

  /// TODO: remove favoriteChannelsIds (work with to/from json for prefs)
  static HomeScreenModel get defModel => HomeScreenModel(
        channelId: '',
        favoriteChannels: [],
        favoriteChannelsIds: [AppConfig.defChannel],
        defChannelId: AppConfig.defChannel,
        channel: Channel.initial(),
        isLoading: true,
        needMoreVideos: false,
        searchChannels: [],
      );

  bool get favChannelsLoading =>
      favoriteChannels.length == favoriteChannelsIds.length;
}
