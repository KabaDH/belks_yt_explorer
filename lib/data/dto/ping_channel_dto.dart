import 'package:belks_tube/core/helpers.dart';
import 'package:belks_tube/domain/data_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ping_channel_dto.freezed.dart';
part 'ping_channel_dto.g.dart';

@freezed
class PingChannelResponseDto with _$PingChannelResponseDto {
  const factory PingChannelResponseDto({
    Map<String, dynamic>? error,
    Map<String, dynamic>? items,
    PageInfoDto? pageInfo,
  }) = _PingChannelResponseDto;

  factory PingChannelResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PingChannelResponseDtoFromJson(json);
}

@freezed
class PageInfoDto with _$PageInfoDto {
  const factory PageInfoDto(int? totalResults) = _PageInfoDto;

  factory PageInfoDto.fromJson(Map<String, dynamic> json) =>
      _$PageInfoDtoFromJson(json);
}

extension PingChannelResponseDtoX on PingChannelResponseDto {
  Either<DataFailures, String> toDomain() {
    return safeToDomain(() {
      if (pageInfo?.totalResults == null) {
        return const Left(DataFailures.error('totalResults is null'));
      }
      String userId = items?[0]['id'] ?? '';

      return Right((pageInfo?.totalResults ?? 0) > 0 ? userId : 'NoSuchUser');
    }, errors: error, items: pageInfo);
  }
}
