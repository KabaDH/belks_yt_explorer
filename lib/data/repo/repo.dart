import 'package:belks_tube/data/repo/base_repository.dart';
import 'package:belks_tube/data/repo/local/local_repo.dart';
import 'package:belks_tube/data/repo/remote/remote_repo.dart';
import 'package:belks_tube/domain/data_failures.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:belks_tube/models/videos_model.dart';
import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repo.g.dart';

@riverpod
Repo repo(RepoRef ref) => Repo(ref);

class Repo implements BaseRepo {
  Repo(this._ref);

  final Ref _ref;

  LocalRepo get _localRepo => _ref.read(localRepoProvider);
  RemoteRepo get _remoteRepo => _ref.read(remoteRepoProvider);

  // Local
  @override
  String getDefChannelId() => _localRepo.getDefChannelId();

  @override
  List<String> getFavoriteChannelsIds() => _localRepo.getFavoriteChannelsIds();

  // Remote
  @override
  Future<Either<DataFailures, Channel>> fetchChannel(
          {required String channelId}) =>
      _remoteRepo.fetchChannel(channelId: channelId);

  @override
  Future<Either<DataFailures, Videos>> fetchVideosFromPlayList(
          {required String channelId, int? maxResults, String? pageToken}) =>
      _remoteRepo.fetchVideosFromPlayList(channelId: channelId);
}
