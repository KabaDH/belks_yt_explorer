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
      required String defChannelId,
      required Channel channel,
      required bool isLoading,
      required bool needMoreVideos,
      required bool favChannelsLoading,
      required List<SearchChannel> searchChannels,
      required double logoOpacity}) = _HomeScreenModel;

  static HomeScreenModel get defModel => HomeScreenModel(
      channelId: '',
      favoriteChannels: [],
      defChannelId: AppConfig.defChannel,
      channel: Channel.initial(),
      isLoading: false,
      needMoreVideos: false,
      favChannelsLoading: false,
      searchChannels: [],
      logoOpacity: 1.0);
}
