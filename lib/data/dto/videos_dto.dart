import 'package:belks_tube/core/helpers.dart';
import 'package:belks_tube/domain/data_failures.dart';
import 'package:belks_tube/models/models.dart';
import 'package:belks_tube/models/videos_model.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:belks_tube/core/consts.dart';

part 'videos_dto.g.dart';

@JsonSerializable()
class VideosResponseDto {
  VideosResponseDto({this.error, this.items, this.nextPageToken});

  final Map<String, dynamic>? error;
  final List<VideosSnippetDto>? items;
  final String? nextPageToken;

  factory VideosResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VideosResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VideosResponseDtoToJson(this);

  @override
  String toString() {
    return 'VideosResponseDto{items: ${items.toString()}, errors: ${error.toString()}, nextPageToken: ${nextPageToken.toString()}';
  }
}

@JsonSerializable()
class VideosSnippetDto {
  VideosSnippetDto({this.snippet});

  final VideoDto? snippet;

  // Map<String, dynamic> data = json.decode(response.body)['items'][0];
  // throw json.decode(response.body)['error']['message'];

  factory VideosSnippetDto.fromJson(Map<String, dynamic> json) =>
      _$VideosSnippetDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VideosSnippetDtoToJson(this);

  @override
  String toString() {
    return 'VideosSnippetDto{snippet: ${snippet.toString()}';
  }
}

@JsonSerializable()
class VideoDto {
  VideoDto(
      {this.resourceId,
      this.title,
      this.thumbnails,
      this.channelTitle,
      this.publishedAt});

  final Map<String, dynamic>? resourceId;
  final String? title;
  final Map<String, dynamic>? thumbnails;
  final String? channelTitle;
  final String? publishedAt;

  factory VideoDto.fromJson(Map<String, dynamic> json) =>
      _$VideoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoDtoToJson(this);

  @override
  String toString() {
    return 'VideoDto{title: $title, channelTitle: $channelTitle';
  }
}

extension VideosResponseDtoX on VideosResponseDto {
  // id: snippet['resourceId']['videoId'],
  // title: snippet['title'],
  // thumbnailUrl: snippet['thumbnails']['high']['url'],
  // channelTitle: snippet['channelTitle'],
  // publishedAt: snippet['publishedAt'].toString(),

  Either<DataFailures, Videos> toDomain() {
    return safeToDomain(() {
      final List<Video> videos = items?.map((e) {
            final snippet = e.snippet;

            return Video(
              id: snippet?.resourceId?['videoId'] ?? '',
              title: snippet?.title ?? '',
              thumbnailUrl: snippet?.thumbnails?['high']['url'] ?? '',
              channelTitle: snippet?.channelTitle ?? '',
              publishedAt:
                  DateTime.parse(snippet?.publishedAt ?? invalidDate.toString())
                      .toLocal(),
            );
          }).toList() ??
          [];

      return Right(Videos(nextPageToken: nextPageToken ?? '', videos: videos));
    }, errors: error, items: items);
  }
}
