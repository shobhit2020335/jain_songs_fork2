import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jain_songs/search_empty_page.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'build_row.dart';

class BuildList extends StatelessWidget {
  final Color colorRowIcon;
  final ScrollController? scrollController;
  final TextEditingController searchController;
  final NativeAd? homeListNativeLowFloorAd;
  final NativeAd? homeListNativeMediumFloorAd;
  final NativeAd? homeListNativeHighFloorAd;

  const BuildList({
    Key? key,
    this.colorRowIcon = Colors.grey,
    this.scrollController,
    required this.searchController,
    this.homeListNativeLowFloorAd,
    this.homeListNativeMediumFloorAd,
    this.homeListNativeHighFloorAd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: ListFunctions.listToShow.length + 1,
      itemBuilder: (context, i) {
        if (i == ListFunctions.listToShow.length ||
            ListFunctions.listToShow.isEmpty) {
          return SearchEmpty(searchController);
        } else {
          return BuildRow(
            ListFunctions.listToShow[i],
            color: colorRowIcon,
            userSearched: searchController.text,
            positionInList: i,
            listNativeLowFloorAd: homeListNativeLowFloorAd,
            listNativeMediumFloorAd: homeListNativeMediumFloorAd,
            listNativeHighFloorAd: homeListNativeHighFloorAd,
          );
        }
      },
    );
  }
}
