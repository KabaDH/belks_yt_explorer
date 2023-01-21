import 'package:belks_tube/core/helpers.dart';
import 'package:belks_tube/domain/data_failures.dart';
import 'package:belks_tube/models/channel_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel_dto.g.dart';

@JsonSerializable()
class ChannelResponseDto {
  ChannelResponseDto({this.error, this.items});

  final Map<String, dynamic>? error;
  final List<ChannelDto>? items;

  // Map<String, dynamic> data = json.decode(response.body)['items'][0];
  // throw json.decode(response.body)['error']['message'];

  factory ChannelResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChannelResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelResponseDtoToJson(this);

  @override
  String toString() {
    return 'ChannelResponseDto{items: ${items.toString()}, errors: ${error.toString()}';
  }
}

@JsonSerializable()
class ChannelDto {
  ChannelDto({this.id, this.snippet, this.statistics, this.contentDetails});

  final String? id;
  final Map<String, dynamic>? snippet;
  final Map<String, dynamic>? statistics;
  final Map<String, dynamic>? contentDetails;

// id: map['id'],
// title: map['snippet']['title'],
// profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
// subscriberCount: map['statistics']['subscriberCount'] ?? 'hidden',
// videoCount: map['statistics']['videoCount'],
// uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],

  factory ChannelDto.fromJson(Map<String, dynamic> json) =>
      _$ChannelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelDtoToJson(this);

  @override
  String toString() {
    return 'ChannelDto{id: $id, snippet: ${snippet.toString()}, statistics: ${statistics.toString()}, contentDetails: ${contentDetails.toString()}';
  }
}

extension ChannelResponseDtoX on ChannelResponseDto {
  Either<DataFailures, Channel> toDomain() {
    return safeToDomain(() {
      final channelDto = items?[0];
      if (channelDto == null) {
        return const Left(DataFailures.error('channel is null'));
      }
      final Channel channel = Channel(
          id: channelDto.id ?? '',
          title: channelDto.snippet?['title'] ?? '',
          profilePictureUrl:
              channelDto.snippet?['thumbnails']['default']['url'] ?? '',
          subscriberCount:
              channelDto.statistics?['subscriberCount'] ?? 'hidden',
          videoCount: int.tryParse(channelDto.statistics?['videoCount']) ?? 0,
          uploadPlaylistId:
              channelDto.contentDetails?['relatedPlaylists']['uploads'] ?? '',
          videos: []);
      return Right(channel);
    }, errors: error, items: items);
  }
}
