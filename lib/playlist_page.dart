import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/buildRow.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'utilities/lists.dart';

class PlaylistPage extends StatefulWidget {
  final PlaylistDetails currentPlaylist;
  //Below Variable is recieved when page is opened from Dynamic link or FCM.
  final String playlistCode;

  PlaylistPage({this.currentPlaylist, this.playlistCode});

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  bool showProgress = true;
  Timer _timerLink;
  PlaylistDetails currentPlaylist;

  void getSongs() async {
    setState(() {
      showProgress = true;
    });
    await FireStoreHelper().getPopularSongs();

    setState(() {
      showProgress = false;
    });
  }

  void setUpPlaylistDetails() {
    if (currentPlaylist.playlistTag.contains('popular')) {
      getSongs();
    } else {
      addElementsToList(currentPlaylist.playlistTag);
      setState(() {
        showProgress = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    listToShow.clear();
    setState(() {
      showProgress = true;
    });

    if (widget.playlistCode == null || widget.playlistCode.length == 0) {
      currentPlaylist = widget.currentPlaylist;
      setUpPlaylistDetails();
    } else {
      currentPlaylist = playlistList.firstWhere((playlist) {
        return playlist.playlistTag.contains(widget.playlistCode);
      }, orElse: () {
        return null;
      });
      if (currentPlaylist == null) {
        Navigator.of(context).pop();
      } else {
        _timerLink = Timer(Duration(milliseconds: 3000), () {
          setUpPlaylistDetails();
        });
      }
    }
  }

  @override
  void dispose() {
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            pinned: true,
            expandedHeight: 200,
            elevation: 20,
            flexibleSpace: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      currentPlaylist != null ? currentPlaylist.title : '',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Pacifico',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    currentPlaylist != null
                        ? currentPlaylist.color
                        : Colors.white,
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              // ignore: missing_return
              (context, index) {
                if (showProgress) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: currentPlaylist != null
                              ? currentPlaylist.color
                              : Colors.indigo,
                        ),
                      ],
                    ),
                  );
                } else if (listToShow.length == 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Text(
                        'Songs loading...\nLike songs to save them in your Favourites playlist.',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                } else if (index < listToShow.length) {
                  return BuildRow(
                    currentSong: listToShow[index],
                    color: currentPlaylist.color,
                  );
                }
              },
              childCount: showProgress
                  ? 1
                  : (listToShow.length == 0 ? 1 : listToShow.length),
            ),
          ),
        ],
      ),
    );
  }
}
