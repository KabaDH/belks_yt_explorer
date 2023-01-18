import 'package:freezed_annotation/freezed_annotation.dart';

import 'models.dart';
part 'channel_model.freezed.dart';

@freezed
class Channel with _$Channel {
  const Channel._();

  const factory Channel({
    required String id,
    required String title,
    required String profilePictureUrl,
    required String subscriberCount,
    required int videoCount,
    required String uploadPlaylistId,
    int? maxResults,
    String? pageToken,
    List<Video>? videos,
  }) = _Channel;

  /// TODO: del in 2.0
  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      subscriberCount: map['statistics']['subscriberCount'] ?? 'hidden',
      videoCount: int.tryParse(map['statistics']['videoCount']) ?? 0,
      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
    );
  }

  factory Channel.initial() => const Channel(
      id: '0',
      title: '',
      profilePictureUrl: '',
      subscriberCount: 'hidden',
      videoCount: 0,
      uploadPlaylistId: '');
}
