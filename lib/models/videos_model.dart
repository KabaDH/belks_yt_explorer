import 'package:belks_tube/models/models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'videos_model.freezed.dart';

@freezed
class Videos with _$Videos {
  const factory Videos({
    required String nextPageToken,
    required List<Video> videos,
  }) = _Videos;
}
