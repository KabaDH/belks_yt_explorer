import 'package:belks_tube/domain/data_failures.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:dartz/dartz.dart';

abstract class BaseRemoteRepo {
  Future<Either<DataFailures, Channel>> fetchChannel({
    required int channelId,
  });
}
