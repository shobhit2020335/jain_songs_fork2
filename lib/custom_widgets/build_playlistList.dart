import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/build_playlistRow.dart';
import 'package:jain_songs/utilities/lists.dart';

class BuildPlaylistList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ListFunctions.playlistList.length * 2,
      itemBuilder: (context, i) {
        if (i % 2 == 1) {
          return Divider();
        } else {
          return BuildPlaylistRow(
            ListFunctions.playlistList[i ~/ 2],
          );
        }
      },
    );
  }
}
