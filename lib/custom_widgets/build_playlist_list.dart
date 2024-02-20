import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/build_playlist_row.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';

class BuildPlaylistList extends StatelessWidget {
  const BuildPlaylistList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Theme.of(context).primaryColor,
        title: const Text(
          'Playlists',
        ),
        centerTitle: true,
        leading: Transform.scale(
          scale: 0.5,
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                ConstWidget.showToast(Globals.welcomeMessage);
              },
              child: Image.asset(
                'images/Logo.png',
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
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
      ),
    );
  }
}
