import 'package:flutter/material.dart';
import 'package:jain_songs/searchEmpty_page.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'buildRow.dart';

class BuildList extends StatelessWidget {
  final Color colorRowIcon;
  final ScrollController? scrollController;
  final TextEditingController searchController;

  BuildList({
    this.colorRowIcon: Colors.grey,
    this.scrollController,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: ListFunctions.listToShow.length + 1,
      itemBuilder: (context, i) {
        if (i == ListFunctions.listToShow.length) {
          return SearchEmpty(searchController);
        } else {
          return BuildRow(
            ListFunctions.listToShow[i],
            color: colorRowIcon,
            userSearched: searchController.text,
            positionInList: i,
          );
        }
      },
    );
  }
}
