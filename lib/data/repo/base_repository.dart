import 'package:belks_tube/domain/data_failures.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:belks_tube/models/videos_model.dart';
import 'package:dartz/dartz.dart';

abstract class BaseRepo {
  // Local
  String getMainChannelId();

  List<String> getFavoriteChannelsIds();

  void setMainChannel(Channel channel);

  void setFavoriteChannelsIds(List<String> favChannelsIds);

  // Remote
  Future<Either<DataFailures, Channel>> fetchChannel({
    required String channelId,
  });

  Future<Either<DataFailures, Videos>> fetchVideosFromPlayList({
    required String playlistId,
    int? maxResults,
    String? pageToken,
  });
}
