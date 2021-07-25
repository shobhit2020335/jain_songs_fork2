import 'package:flutter/material.dart';
import 'package:jain_songs/searchEmpty_page.dart';
import 'package:jain_songs/utilities/lists.dart';
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
    /*required*/ @required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return showProgress
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.indigo,
              ),
            ),
          )
        : ListView.builder(
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
            },
          );
  }
}
