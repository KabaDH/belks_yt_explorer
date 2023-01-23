import 'package:belks_tube/core/helpers.dart';
import 'package:belks_tube/domain/data_failures/data_failures.dart';
import 'package:belks_tube/domain/search/search_model.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_channel_dto.freezed.dart';
part 'search_channel_dto.g.dart';

@freezed
class SearchChannelResponseDto with _$SearchChannelResponseDto {
  const factory SearchChannelResponseDto({
    Map<String, dynamic>? error,
    List<SearchChannelDto>? items,
    String? nextPageToken,
  }) = _SearchChannelResponseDto;

  factory SearchChannelResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SearchChannelResponseDtoFromJson(json);
}

@freezed
class SearchChannelDto with _$SearchChannelDto {
  const factory SearchChannelDto({SearchSnippetDto? snippet}) =
      _SearchChannelDto;

  factory SearchChannelDto.fromJson(Map<String, dynamic> json) =>
      _$SearchChannelDtoFromJson(json);
}

@freezed
class SearchSnippetDto with _$SearchSnippetDto {
  const factory SearchSnippetDto({
    String? channelId,
    String? title,
    Map<String, dynamic>? thumbnails,
    String? description,
  }) = _SearchSnippetDto;

  factory SearchSnippetDto.fromJson(Map<String, dynamic> json) =>
      _$SearchSnippetDtoFromJson(json);
// id: map['channelId'],
// title: map['title'],
// profilePictureUrl: map['thumbnails']['default']['url'],
// description: map['description'] ?? 'hidden',

}

extension SearchChannelResponseDtoX on SearchChannelResponseDto {
  Either<DataFailures, SearchResult> toDomain() {
    return safeToDomain(() {
      if (items?[0].snippet == null) {
        return const Left(DataFailures.error('SearchSnippetDto is null'));
      }

      List<SearchChannel> res = items
              ?.map((e) => SearchChannel(
                  id: e.snippet?.channelId ?? '',
                  title: e.snippet?.title ?? '',
                  profilePictureUrl:
                      e.snippet?.thumbnails?['default']['url'] ?? '',
                  description: e.snippet?.description ?? 'hidden'))
              .toList() ??
          [];

      return Right(
          SearchResult(nextPageToken: nextPageToken ?? '', channels: res));
    }, errors: error, items: items);
  }
}
