import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/buildRow.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'utilities/lists.dart';

class PlaylistPage extends StatelessWidget {
  final PlaylistDetails currentPlaylist;

  //TODO: Test this page changes on app.

  //TODO: Change this according to the playlist page to open.
  PlaylistPage(this.currentPlaylist) {
    addElementsToList(currentPlaylist.color);
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
                return BuildRow(
                  currentSong: listToShow[index],
                  color: currentPlaylist.color,
                );
              },
              childCount: listToShow.length,
            ),
          ),
        ],
      ),
    );
  }
}
