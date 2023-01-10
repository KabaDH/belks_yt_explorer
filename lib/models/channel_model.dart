import 'models.dart';

class Channel {
  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscriberCount;
  final int videoCount;
  final String uploadPlaylistId;
  final int? maxResults;
  final String? pageToken;
  List<Video>? videos;

  Channel({
    required this.id,
    required this.title,
    required this.profilePictureUrl,
    required this.subscriberCount,
    required this.videoCount,
    required this.uploadPlaylistId,
    this.maxResults,
    this.pageToken,
    this.videos,
  });

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
  factory Channel.initial() => Channel(
      id: '0',
      title: '',
      profilePictureUrl: '',
      subscriberCount: 'hidden',
      videoCount: 0,
      uploadPlaylistId: '');
}
