import 'package:belks_tube/domain/data_failures.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:belks_tube/models/videos_model.dart';
import 'package:dartz/dartz.dart';

abstract class BaseRepo {
  // Local
  String getDefChannelId();

  List<String> getFavoriteChannelsIds();

  // Remote
  Future<Either<DataFailures, Channel>> fetchChannel({
    required String channelId,
  });

  Future<Either<DataFailures, Videos>> fetchVideosFromPlayList({
    required String channelId,
    int? maxResults,
    String? pageToken,
  });
}
