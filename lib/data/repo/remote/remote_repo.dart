import 'package:belks_tube/data/dto/channel_dto.dart';
import 'package:belks_tube/data/providers/app_config.dart';
import 'package:belks_tube/data/repo/remote/base_remote_repository.dart';
import 'package:belks_tube/data/repo/remote/http/api_client.dart';
import 'package:belks_tube/data/repo/remote/http/rest_client.dart';
import 'package:belks_tube/domain/data_failures.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_repo.g.dart';

@riverpod
RemoteRepo remoteRepo(RemoteRepoRef ref) => RemoteRepo(ref);

class RemoteRepo with RepositoryImplMixin implements BaseRemoteRepo {
  RemoteRepo(this.ref);

  final Ref ref;

  RestClient get client => ref.read(apiClientProvider);
  final String _key = AppConfig.apiKey;

  @override
  Future<Either<DataFailures, Channel>> fetchChannel(
      {required int channelId}) async {
    return safeFunc(() async {
      final dto = await client.fetchChannel(channelId: channelId, key: _key);
      return dto.toDomain();
    });
  }
}

mixin RepositoryImplMixin {
  Future<Either<DataFailures, R>> safeFunc<R>(
      Future<Either<DataFailures, R>> Function() f) async {
    try {
      final r = await f.call();
      return r;
    } on Error catch (e) {
      return left(DataFailures.error(e.toString()));
    } on Exception catch (e) {
      return left(DataFailures.error(e.toString()));
    }
  }
}
