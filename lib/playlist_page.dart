import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/buildRow.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'utilities/lists.dart';

class PlaylistPage extends StatelessWidget {
  final PlaylistDetails currentPlaylist;

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
            title: Text(currentPlaylist.title),
            floating: true,
            expandedHeight: 200,
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
