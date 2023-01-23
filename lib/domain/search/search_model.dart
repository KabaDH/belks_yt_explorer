import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_model.freezed.dart';
part 'search_model.g.dart';

@freezed
class SearchChannel with _$SearchChannel {
  const factory SearchChannel(
      {required String id,
      required String title,
      required String profilePictureUrl,
      required String description}) = _SearchChannel;

  factory SearchChannel.fromMap(Map<String, dynamic> map) {
    return SearchChannel(
      id: map['channelId'],
      title: map['title'],
      profilePictureUrl: map['thumbnails']['default']['url'],
      description: map['description'] ?? 'hidden',
    );
  }

  factory SearchChannel.fromJson(Map<String, dynamic> json) =>
      _$SearchChannelFromJson(json);
}

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required String nextPageToken,
    required List<SearchChannel> channels,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}
