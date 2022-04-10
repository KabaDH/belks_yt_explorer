import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:belks_yt_explorer/models/models.dart';
import 'screens.dart';
import 'package:belks_yt_explorer/services/api_services.dart';

import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final String channelId = 'UCjzHeG1KWoonmf9d5KBvSiw';
  late List<String> favoriteChannelsID;
  List<Channel> favoriteChannels = [];
  late String defChannelId;
  late SharedPreferences storage;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late Channel _channel; //загруженный канал в текущий момент
  bool _isLoading = true;
  bool _needMoreVideos = false;
  bool _favChannelsLoading = true;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    setState(() {
      _isLoading = true;
    });
    //загружаем канал по умолчанию
    String _defChannelId;
    final SharedPreferences prefs = await _prefs;
    prefs.containsKey('defChannelId')
        ? _defChannelId = prefs.getString('defChannelId')!
        : _defChannelId = 'UCjzHeG1KWoonmf9d5KBvSiw';
    //проверяем сохраненные каналы
    List<String> _favoriteChannelsID;
    prefs.containsKey('favoriteChannelsID')
        ? _favoriteChannelsID = prefs.getStringList('favoriteChannelsID')!
        : _favoriteChannelsID = ['UCjzHeG1KWoonmf9d5KBvSiw'];
    //инициализируем каналы
    List<Channel> _favoriteChannels = [];

    if (_favoriteChannelsID.isNotEmpty) {
      _favoriteChannelsID.forEach((e) async {
        Channel _tempChannel;
        _tempChannel = await APIService.instance.fetchChannel(channelId: e);
        _favoriteChannels.add(_tempChannel);
        if (_favoriteChannels.length == _favoriteChannelsID.length) {
          setState(() {
            _favChannelsLoading = false;
          });
        }
      });
    }

    Channel channel =
        await APIService.instance.fetchChannel(channelId: _defChannelId);
    setState(() {
      _channel = channel;
      favoriteChannelsID =
          _favoriteChannelsID; //возможно убрать. Далее не планируем использовать
      _isLoading = false;
      favoriteChannels = _favoriteChannels;
    });
  }

  _videosBuilder(Video video) {
    DateTime _posted = DateTime.parse(video.publishedAt).toLocal();
    String _postedDate = DateFormat('dd/MM/yyyy HH:mm').format(_posted);

    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => VideoScreen(id: video.id))),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 6)
        ]),
        child: Row(
          children: [
            Image.network(
              '${video.thumbnailUrl}',
              width: 170,
              height: 130,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${video.title}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(
                    _postedDate,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _needMoreVideos = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlayList(playListId: _channel.uploadPlaylistId);
    setState(() {
      _channel.videos!..addAll(moreVideos);
      // moreVideos.forEach((video) {
      //   _channel.videos!.add(video);
      // });
    });
    _needMoreVideos = false;
  }

//элементы drawer
  _buildFavorites() {
    return Expanded(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView.builder(
            itemCount: favoriteChannels.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _channel = favoriteChannels[index];
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 80,
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(80),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 3)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image(
                          image: NetworkImage(
                              '${favoriteChannels[index].profilePictureUrl}'),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                          child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${favoriteChannels[index].title}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 2)
                                  ]),
                            ),
                            Text(
                              'Updated ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(favoriteChannels[index].videos![0].publishedAt).toLocal())}',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 12),
                            )
                          ],
                        ),
                      )),
                      SizedBox(
                        width: 7,
                      ),
                      IconButton(
                          onPressed: () =>
                              _removeDialog(favoriteChannels[index]),
                          icon: Icon(
                            Icons.cancel,
                            size: 30,
                            color: Colors.black54,
                          ))
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  //Button remove fav pressed
  Future<void> _removeDialog(Channel c) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //user must tap the button
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation require'),
            content: SingleChildScrollView(
              child: RichText(
                text: TextSpan(
                    text: 'Remove channel ',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                          text: '${c.title}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      TextSpan(
                          text: ' from list?',
                          style: TextStyle(color: Colors.black, fontSize: 16))
                    ]),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () =>
                      {Navigator.of(context).pop(), _channelRemoval(c)},
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }

  Future<void> _channelRemoval(Channel c) async {
    List<Channel> favChannels;
    favChannels = favoriteChannels;
    SharedPreferences prefs = await _prefs;

    if (c != _channel) {
      setState(() {
        favoriteChannels.remove(c);
        favoriteChannelsID.remove(c.id);
        prefs.setStringList('favoriteChannelsID', favoriteChannelsID);
      });
    } else {
      favChannels.remove(c);
      if (favChannels.isNotEmpty) {
        setState(() {
          _isLoading = true;
          favoriteChannels = favChannels;
          favoriteChannelsID.remove(c.id);
          _channel = favoriteChannels[0];
          prefs.setStringList('favoriteChannelsID', favoriteChannelsID);
          _isLoading = false;
        });
      } else {
        Channel tmpChannel;
        tmpChannel =
            await APIService.instance.fetchChannel(channelId: channelId);

        setState(() {
          _isLoading = true;

          prefs.remove('defChannelId');
          prefs.remove('favoriteChannelsID');

          favoriteChannels.remove(c);
          favoriteChannelsID.remove(c.id);
          _channel = tmpChannel;
          _isLoading = false;
        });
      }
    }
  }

  _newChannelInit(String c) async {
    bool ping = await APIService.instance.pingChannel(channelId: c);
    String pingUserID = await APIService.instance.pingChannelUser(userID: c);

    _newChannelAccepted(String c) async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Channel OK'),
        duration: Duration(seconds: 3),
      ));

      if (favoriteChannelsID.contains(c)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Can`t add - u have this channel in favorites'),
          duration: Duration(seconds: 3),
        ));
      } else {
        favoriteChannelsID.add(c);
        print(favoriteChannelsID);
        Channel newchannel =
            await APIService.instance.fetchChannel(channelId: c);
        SharedPreferences prefs = await _prefs;
        prefs.setString('defChannelId', c);
        prefs.setStringList('favoriteChannelsID', favoriteChannelsID);

        setState(() {
          _channel = newchannel;
          favoriteChannels.add(newchannel);
        });
      }
    }

    if (!ping) {
      if (pingUserID == 'NoSuchUser') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No such channel'),
          duration: Duration(seconds: 3),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Channel OK by UserID'),
          duration: Duration(seconds: 3),
        ));
        _newChannelAccepted(pingUserID);
      }
    } else {
      _newChannelAccepted(c); //Accepted by ChannelID
    }
  }

  _menuAddFav() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: TextField(
          onSubmitted: (newfavorite) {
            _newChannelInit(newfavorite);
          },
          decoration: InputDecoration(
            hintText: 'ChannelID or UserName',
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: _isLoading
            ? Text(
                'Belk`s YouTube channel explorer',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            : ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    image: NetworkImage('${_channel.profilePictureUrl}'),
                    height: 50,
                    width: 50,
                  ),
                ),
                title: Text(
                  '${_channel.title}',
                  style: TextStyle(color: Colors.white, fontSize: 16, shadows: [
                    Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 2),
                        blurRadius: 6)
                  ]),
                ),
                subtitle: Text(
                  '${_channel.subscriberCount} subscribers',
                  style: TextStyle(color: Colors.white, fontSize: 12, shadows: [
                    Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 2),
                        blurRadius: 3)
                  ]),
                ),
                // tileColor: Colors.red,
              ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ))
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_needMoreVideos &&
                    _channel.videos!.length != int.parse(_channel.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreVideos();
                }
                return false;
              },
              child: ListView.builder(
                  itemCount: _channel.videos!.length,
                  itemBuilder: (context, index) {
                    Video video = _channel.videos![index];
                    return _videosBuilder(video);
                  }),
            ),
      drawer: favoriteChannels.isEmpty
          ? Center(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _menuAddFav(),
              ],
            ))
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.835,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: _favChannelsLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ))
                      : Column(
                          children: [
                            _menuAddFav(),
                            _buildFavorites(),
                          ],
                        ),
                ),
              ),
            ),
    );
  }
}
