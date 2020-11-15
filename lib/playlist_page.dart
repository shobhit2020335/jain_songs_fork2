import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/buildRow.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'utilities/lists.dart';

class PlaylistPage extends StatefulWidget {
  final PlaylistDetails currentPlaylist;

  PlaylistPage(this.currentPlaylist);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  bool showProgress = false;
  PlaylistDetails currentPlaylist;

  void getSongs() async {
    setState(() {
      showProgress = true;
    });
    await FireStoreHelper().getSongs('');

    addElementsToList('Popular');

    setState(() {
      showProgress = false;
    });
  }

  @override
  void initState() {
    super.initState();
    listToShow.clear();
    currentPlaylist = widget.currentPlaylist;
    if (currentPlaylist.title.contains('Popular')) {
      getSongs();
    } else {
      addElementsToList(currentPlaylist.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // title: Text('Liked Songs'),
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
                      currentPlaylist.title,
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
                    currentPlaylist.color,
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (showProgress) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: currentPlaylist.color,
                        ),
                      ],
                    ),
                  );
                } else if (index < songList.length) {
                  return BuildRow(
                    currentSong: listToShow[index],
                    color: currentPlaylist.color,
                  );
                }
              },
              childCount: showProgress ? 1 : listToShow.length,
            ),
          ),
        ],
      ),
    );
  }
}
