import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jain_songs/search_empty_page.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'build_row.dart';

class BuildList extends StatelessWidget {
  final Color colorRowIcon;
  final ScrollController? scrollController;
  final TextEditingController searchController;
  final BannerAd? homePageBottomBannerAd;

  const BuildList({
    Key? key,
    this.colorRowIcon = Colors.grey,
    this.scrollController,
    required this.searchController,
    this.homePageBottomBannerAd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (homePageBottomBannerAd != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: SizedBox(
                width: homePageBottomBannerAd!.size.width.toDouble(),
                height: homePageBottomBannerAd!.size.height.toDouble(),
                child: AdWidget(ad: homePageBottomBannerAd!),
              ),
            ),
          ),
        ListView.builder(
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
        ),
      ],
    );
  }
}
