import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/build_playlist_row.dart';
import 'package:jain_songs/utilities/lists.dart';

class BuildPlaylistList extends StatelessWidget {
  const BuildPlaylistList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ListFunctions.playlistList.length * 2,
      itemBuilder: (context, i) {
        if (i % 2 == 1) {
          return const Divider();
        } else {
          return BuildPlaylistRow(
            ListFunctions.playlistList[i ~/ 2],
          );
        }
      },
    );
  }
}
