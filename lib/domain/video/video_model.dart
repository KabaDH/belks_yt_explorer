import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_model.freezed.dart';
part 'video_model.g.dart';

@freezed
class Video with _$Video {
  const factory Video(
      {required String id,
      required String title,
      required String thumbnailUrl,
      required String channelTitle,
      required DateTime publishedAt}) = _Video;

  factory Video.fromMap(Map<String, dynamic> snippet) {
    return Video(
      id: snippet['resourceId']['videoId'],
      title: snippet['title'],
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      channelTitle: snippet['channelTitle'],
      publishedAt: snippet['publishedAt'],
    );
  }

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
}
