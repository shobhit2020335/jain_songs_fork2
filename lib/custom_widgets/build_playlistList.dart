import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/build_playlistRow.dart';
import 'package:jain_songs/utilities/songs_list.dart';

//TODO: configure list for playlist.

class BuildPlaylistList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: playlistList.length,
      itemBuilder: (context, i) {
        return BuildPlaylistRow();
      },
    );
  }
}
