import 'package:flutter/material.dart';
import 'package:jain_songs/searchEmpty_page.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'buildRow.dart';

class BuildList extends StatelessWidget {
  final bool showProgress;
  final Color colorRowIcon;
  final ScrollController scrollController;
  final TextEditingController searchController;

  BuildList({
    this.showProgress,
    this.colorRowIcon: Colors.grey,
    this.scrollController,
    @required this.searchController,
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
        child: ListView.builder(
            controller: scrollController,
            itemCount: listToShow.length + 1,
            itemBuilder: (context, i) {
              if (i == listToShow.length) {
                return SearchEmpty(searchController);
              } else {
                return BuildRow(
                  currentSong: listToShow[i],
                  color: colorRowIcon,
                );
              }
            }));
  }
}
