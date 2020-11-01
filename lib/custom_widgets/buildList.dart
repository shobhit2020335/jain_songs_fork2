import 'package:flutter/material.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'buildRow.dart';

class BuildList extends StatelessWidget {
  final bool showProgress;
  final Color colorRowIcon;
  //The lisToShow might be causing error. See constructor.

  BuildList({
    this.showProgress,
    this.colorRowIcon: Colors.grey,
  }) {
    listToShow.clear();
    if (colorRowIcon == Colors.grey) {
      for (int i = 0; i < songList.length; i++) {
        listToShow.add(songList[i]);
      }
    } else {
      for (int i = 0; i < songList.length; i++) {
        if (songList[i].isLiked == true) {
          listToShow.add(songList[i]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Color(0xFF54BEE6),
      ),
      color: Colors.white,
      opacity: 1,
      inAsyncCall: showProgress,
      child: ListView.builder(
          itemCount: listToShow.length,
          itemBuilder: (context, i) {
            return BuildRow(
              currentSong: listToShow[i],
              color: colorRowIcon,
            );
          }),
    );
  }
}
