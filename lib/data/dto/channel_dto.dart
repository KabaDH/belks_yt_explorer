import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel_dto.g.dart';

@JsonSerializable()
class ChannelResponseDto {
  ChannelResponseDto({this.errors, this.items});

  final Map<String, dynamic>? errors;
  final List<Map<String, dynamic>>? items;

  // Map<String, dynamic> data = json.decode(response.body)['items'][0];
  // throw json.decode(response.body)['error']['message'];

  factory ChannelResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChannelResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelResponseDtoToJson(this);

  @override
  String toString() {
    return 'ChannelResponseDto{items: ${items.toString()}, errors: ${errors.toString()}';
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
