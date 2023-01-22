import 'package:belks_tube/core/ext.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'models.dart';

part 'channel_model.freezed.dart';
part 'channel_model.g.dart';

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
    required List<Video> videos,
    int? maxResults,
    String? pageToken,
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
        videos: []);
  }

  factory Channel.initial() => const Channel(
      id: '0',
      title: '',
      profilePictureUrl: '',
      subscriberCount: 'hidden',
      videoCount: 0,
      uploadPlaylistId: '',
      videos: []);

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);

  String get lastPublishedAt =>
      'Updated ${videos[0].publishedAt.convertDateTimeForUi() ?? ''}';
}
