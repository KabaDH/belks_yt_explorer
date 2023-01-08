import 'package:belks_tube/data/dto/channel_dto.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @POST('/youtube/v3/channels')
  Future<ChannelResponseDto> fetchChannel({
    @Query('id') required int channelId,
    @Query('part') String part = 'snippet,contentDetails,statistics',
  });

  @POST('/youtube/v3/playlistItems')
  Future<ChannelResponseDto> fetchVideosFromPlayList({
    @Query('playlistId') required int channelId,
    @Query('part') String part = 'snippet',
    @Query('maxResults') required int maxResults,
    @Query('pageToken') required String pageToken,
  });
}
