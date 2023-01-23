import 'package:belks_tube/domain/channel/channel_model.dart';
import 'package:belks_tube/domain/data_failures/data_failures.dart';
import 'package:belks_tube/domain/search/search_model.dart';
import 'package:belks_tube/domain/videos/videos_model.dart';
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

  Future<Either<DataFailures, SearchResult>> fetchSearchResults({
    required String searchRequest,
    int? maxResults,
    String? pageToken,
  });
}
