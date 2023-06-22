import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/build_row.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'utilities/lists.dart';

class PlaylistPage extends StatefulWidget {
  final PlaylistDetails? currentPlaylist;
  //Below Variable is recieved when page is opened from Dynamic link or FCM.
  final String? playlistCode;

  const PlaylistPage({Key? key, this.currentPlaylist, this.playlistCode})
      : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  bool showProgress = true;
  Timer? _timerLink;
  PlaylistDetails? currentPlaylist;

  void setUpPlaylistDetails() {
    ListFunctions().addElementsToList(currentPlaylist!.playlistTag);
    setState(() {
      showProgress = false;
    });
  }

  @override
  void initState() {
    super.initState();
    ListFunctions.listToShow.clear();
    setState(() {
      showProgress = true;
    });

    if (widget.playlistCode == null || widget.playlistCode!.isEmpty) {
      currentPlaylist = widget.currentPlaylist;
      setUpPlaylistDetails();
    } else {
      currentPlaylist = ListFunctions.playlistList.firstWhere((playlist) {
        return playlist!.playlistTag.contains(widget.playlistCode!);
      }, orElse: () {
        return null;
      });
      if (currentPlaylist == null) {
        Navigator.of(context).pop();
      } else {
        _timerLink = Timer(const Duration(milliseconds: 5000), () {
          if (ListFunctions.songList.isNotEmpty) {
            setUpPlaylistDetails();
          } else {
            _timerLink?.cancel();
            _timerLink = Timer(const Duration(milliseconds: 10000), () {
              if (ListFunctions.songList.isNotEmpty) {
                setUpPlaylistDetails();
              } else {
                ConstWidget.showSimpleToast(
                    context, 'Internet connection might be slow! Try again.');
                Navigator.of(context).pop();
              }
            });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    if (_timerLink != null) {
      _timerLink?.cancel();
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
                    const SizedBox(height: 15),
                    Text(
                      currentPlaylist != null ? currentPlaylist!.title : '',
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.grey[850]!,
                    currentPlaylist != null
                        ? currentPlaylist!.color!
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
                        const SizedBox(
                          height: 200,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: currentPlaylist != null
                              ? currentPlaylist!.color
                              : Colors.indigo,
                        ),
                      ],
                    ),
                  );
                } else if (ListFunctions.listToShow.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      Text(
                        'Songs loading...\nLike songs to save them in your Favourites playlist.',
                        style: Theme.of(context).primaryTextTheme.subtitle2,
                      ),
                    ],
                  );
                } else if (index < ListFunctions.listToShow.length) {
                  return BuildRow(
                    ListFunctions.listToShow[index],
                    color: currentPlaylist!.color,
                    playlist: currentPlaylist,
                    positionInList: index,
                  );
                }
                return null;
              },
              childCount: showProgress
                  ? 1
                  : (ListFunctions.listToShow.isEmpty
                      ? 1
                      : ListFunctions.listToShow.length),
            ),
          ),
        ],
      ),
    );
  }
}
