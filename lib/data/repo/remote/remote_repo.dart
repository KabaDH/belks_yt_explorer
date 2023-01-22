import 'package:belks_tube/core/helpers.dart';
import 'package:belks_tube/data/dto/channel_dto.dart';
import 'package:belks_tube/data/dto/ping_channel_dto.dart';
import 'package:belks_tube/data/dto/search_channel_dto.dart';
import 'package:belks_tube/data/dto/videos_dto.dart';
import 'package:belks_tube/data/repo/remote/base_remote_repository.dart';
import 'package:belks_tube/data/repo/remote/http/api_client.dart';
import 'package:belks_tube/data/repo/remote/http/rest_client.dart';
import 'package:belks_tube/domain/data_failures.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:belks_tube/models/search_model.dart';
import 'package:belks_tube/models/videos_model.dart';
import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_repo.g.dart';

@riverpod
RemoteRepo remoteRepo(RemoteRepoRef ref) => RemoteRepo(ref);

class RemoteRepo with RepositoryImplMixin implements BaseRemoteRepo {
  RemoteRepo(this._ref);

  final Ref _ref;

  RestClient get _client => _ref.read(apiClientProvider);

  @override
  Future<Either<DataFailures, Channel>> fetchChannel(
      {required String channelId}) async {
    return safeFunc(() async {
      final dto = await _client.fetchChannel(channelId: channelId);
      return dto.toDomain();
    });
  }

  @override
  Future<Either<DataFailures, Videos>> fetchVideosFromPlayList(
      {required String playlistId, int? maxResults, String? pageToken}) {
    return safeFunc(() async {
      final dto = await _client.fetchVideosFromPlayList(
          playlistId: playlistId,
          maxResults: maxResults ?? 8,
          pageToken: pageToken);
      return dto.toDomain();
    });
  }

  @override
  Future<Either<DataFailures, List<SearchChannel>>> fetchSearchResults(
      {required String searchRequest, int? maxResults, String? pageToken}) {
    return safeFunc(() async {
      final dto = await _client.fetchSearchResults(
          searchRequest: searchRequest,
          maxResults: maxResults ?? 8,
          pageToken: pageToken);
      return dto.toDomain();
    });
  }

  @override
  Future<Either<DataFailures, String>> pingChannel({required String channel}) {
    return safeFunc(() async {
      final dto = await _client.pingChannel(channelId: channel);
      return dto.toDomain();
    });
  }

  @override
  Future<Either<DataFailures, String>> pingChannelUserName(
      {required String userName}) {
    return safeFunc(() async {
      final dto = await _client.pingChannel(userName: userName);
      return dto.toDomain();
    });
  }
}
