import 'package:flutter/material.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'buildRow.dart';

class BuildList extends StatelessWidget {
  final bool showProgress;
  final Color colorRowIcon;
  final ScrollController scrollController;

  BuildList({
    this.showProgress,
    this.colorRowIcon: Colors.grey,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Color(0xFF54BEE6),
      ),
      color: Colors.white,
      opacity: 1,
      inAsyncCall: showProgress,
      child: listToShow.length > 0
          ? ListView.builder(
              controller: scrollController,
              itemCount: listToShow.length,
              itemBuilder: (context, i) {
                return BuildRow(
                  currentSong: listToShow[i],
                  color: colorRowIcon,
                );
              })
          : Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 10,
              ),
              child: Text(
                'No Songs Available for the filter. Apply other filter or search something else.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
    );
  }
}
