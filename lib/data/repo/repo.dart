import 'package:belks_tube/data/repo/base_repository.dart';
import 'package:belks_tube/data/repo/local/local_repo.dart';
import 'package:belks_tube/data/repo/remote/remote_repo.dart';
import 'package:belks_tube/domain/data_failures.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:belks_tube/models/videos_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
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
  String getMainChannelId() => _localRepo.getDefChannelId();

  @override
  void setMainChannel(Channel channel) => _localRepo.setMainChannel(channel);

  @override
  List<String> getFavoriteChannelsIds() => _localRepo.getFavoriteChannelsIds();

  @override
  void setFavoriteChannelsIds(List<String> favChannelsIds) =>
      _localRepo.setFavoriteChannelsIds(favChannelsIds);

  // Remote
  @override
  Future<Either<DataFailures, Channel>> fetchChannel(
          {required String channelId}) =>
      _remoteRepo.fetchChannel(channelId: channelId);

  @override
  Future<Either<DataFailures, Videos>> fetchVideosFromPlayList(
          {required String playlistId,
          int? maxResults,
          String? pageToken}) async =>
      await _remoteRepo.fetchVideosFromPlayList(
          playlistId: playlistId, maxResults: maxResults, pageToken: pageToken);
}
