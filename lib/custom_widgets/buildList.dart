import 'package:flutter/material.dart';
import 'package:jain_songs/utilities/songs_list.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'buildRow.dart';

class BuildList extends StatelessWidget {
  final bool showProgress;

  BuildList({this.showProgress});

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
          itemCount: songList.length,
          itemBuilder: (context, i) {
            return BuildRow(
              currentSong: songList[i],
            );
          }),
    );
  }
}
