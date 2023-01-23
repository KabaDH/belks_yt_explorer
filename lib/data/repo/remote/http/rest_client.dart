import 'package:belks_tube/data/dto/channel/channel_dto.dart';
import 'package:belks_tube/data/dto/search_channel/search_channel_dto.dart';
import 'package:belks_tube/data/dto/videos/videos_dto.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  // Follow the order of the fields in request!!!
  // (part => maxResults => playlistId ...)

  @GET('/youtube/v3/channels')
  Future<ChannelResponseDto> fetchChannel({
    @Query('part') String part = 'snippet,contentDetails,statistics',
    @Query('id') required String channelId,
  });

  @GET('/youtube/v3/playlistItems')
  Future<VideosResponseDto> fetchVideosFromPlayList({
    @Query('part') String part = 'snippet',
    @Query('maxResults') required int maxResults,
    @Query('playlistId') required String playlistId,
    @Query('pageToken') String? pageToken,
  });

  @GET('/youtube/v3/search')
  Future<SearchChannelResponseDto> fetchSearchResults({
    @Query('part') String part = 'snippet',
    @Query('maxResults') required int maxResults,
    @Query('q') required String searchRequest,
    @Query('type') String type = 'channel',
    @Query('pageToken') String? pageToken,
  });
}
