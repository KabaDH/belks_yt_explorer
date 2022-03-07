import 'dart:convert';
import 'dart:io';

import 'package:belks_yt_explorer/models/models.dart';
import 'package:belks_yt_explorer/utilites/keys.dart';
import 'package:http/http.dart' as http;

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();
  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';
  String _lastPlayListId = '';

  Future<Channel> fetchChannel({required String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet,contentDetails,statistics',
      'id': channelId,
      'key': API_KEY,
    };

    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    ///Get Channel
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      ///Fetch first batch of videos from uploads playlist
      print(channel.uploadPlaylistId);

      channel.videos =
          await fetchVideosFromPlayList(playListId: channel.uploadPlaylistId);
      // channel.videos!.forEach((video) {
      //   print(video.title);
      // });
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlayList(
      {required String playListId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playListId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };

    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    ///Get Playlist Videos
    if (!(_lastPlayListId == playListId) || _lastPlayListId == '') {
      _nextPageToken = '';
    }
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _lastPlayListId = playListId;
      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      ///Fetch first eight videos from uploads playlist
      List<Video> videos = [];

      videosJson.forEach((json) => videos.add(
            Video.fromMap(json['snippet']),
          ));
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  //Check channel by channelID
  Future<bool> pingChannel({required String channelId}) async {
    int _pong;

    Map<String, String> parameters = {
      'part': 'snippet',
      'id': channelId,
      'key': API_KEY,
    };

    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    ///Get Channel
    var _response = await http.get(uri, headers: headers);

    _pong = json.decode(_response.body)['pageInfo']['totalResults'];
    if (_pong == 0) {
      return false;
    } else {
      return true;
    }
  }

  //Check channel by userID
  Future<String> pingChannelUser({required String userID}) async {
    int _pong;

    Map<String, String> parameters = {
      'part': 'id',
      'forUsername': userID,
      'key': API_KEY,
    };

    Uri uri = Uri.https(_baseUrl, '/youtube/v3/channels', parameters);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _pong = data['pageInfo']['totalResults'];

      if (_pong == 0) {
        return 'NoSuchUser';
      } else {
        return data['items'][0]['id'];
      }
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
