import 'package:belks_tube/domain/data_failures.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:belks_tube/models/search_model.dart';
import 'package:belks_tube/models/videos_model.dart';
import 'package:dartz/dartz.dart';

abstract class BaseRemoteRepo {
  Future<Either<DataFailures, Channel>> fetchChannel({
    required String channelId,
  });

  Future<Either<DataFailures, Videos>> fetchVideosFromPlayList({
    required String playlistId,
    int? maxResults,
    String? pageToken,
  });

  Future<Either<DataFailures, List<SearchChannel>>> fetchSearchResults({
    required String searchRequest,
    int? maxResults,
    String? pageToken,
  });

  Future<Either<DataFailures, String>> pingChannel(
      {required String channel});

  Future<Either<DataFailures, String>> pingChannelUserName(
      {required String userName});
}
