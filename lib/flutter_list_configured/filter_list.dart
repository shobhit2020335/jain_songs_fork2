import 'package:flutter/material.dart';
import 'package:jain_songs/flutter_list_configured/src/filter_list_widget.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'filters.dart';

class FilterListDialog {
  static Future<List<Filters>> display(
    context, {
    double? height,
    double? width,
    double borderRadius = 20,
    String headlineText = "Select here",
    String searchFieldHintText = "Search here",
    bool hideSelectedTextCount = true,
    bool hideSearchField = false,
    bool hidecloseIcon = true,
    bool hideheader = false,
    bool hideheaderText = true,
    Color closeIconColor = Colors.grey,
    Color headerTextColor = Colors.black,
    Color applyButonTextColor = Colors.white,
    Color applyButonTextBackgroundColor = Colors.indigo,
    Color allResetButonColor = Colors.indigo,
    Color selectedTextColor = Colors.white,
    Color backgroundColor = Colors.white,
    Color unselectedTextColor = Colors.black,
    Color searchFieldBackgroundColor = const Color(0xfff5f5f5),
    Color selectedTextBackgroundColor = Colors.indigo,
    Color unselectedTextbackGroundColor = const Color(0xfff8f8f8),
    Function(List<Filters>)? onApplyButtonClick,
    Function(List<Filters>)? onResetButtonClick,
  }) async {
    if (height == null) {
      height = MediaQuery.of(context).size.height * .8;
    }
    if (width == null) {
      width = MediaQuery.of(context).size.width;
    }
    // ignore: unused_local_variable
    var list = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: height,
            width: width,
            color: Colors.transparent,
            child: FilterListWidget(
              height: height,
              width: width,
              borderRadius: borderRadius,
              headlineText: headlineText,
              searchFieldHintText: searchFieldHintText,
              allResetButonColor: allResetButonColor,
              applyButonTextBackgroundColor: applyButonTextBackgroundColor,
              applyButonTextColor: applyButonTextColor,
              backgroundColor: backgroundColor,
              closeIconColor: closeIconColor,
              headerTextColor: headerTextColor,
              searchFieldBackgroundColor: searchFieldBackgroundColor,
              selectedTextBackgroundColor: selectedTextBackgroundColor,
              selectedTextColor: selectedTextColor,
              hideSelectedTextCount: hideSelectedTextCount,
              unselectedTextbackGroundColor: unselectedTextbackGroundColor,
              unselectedTextColor: unselectedTextColor,
              hidecloseIcon: hidecloseIcon,
              hideHeader: hideheader,
              hideheaderText: hideheaderText,
              hideSearchField: hideSearchField,
              onApplyButtonClick: onApplyButtonClick,
              onResetButtonClick: onResetButtonClick,
            ),
          ),
        );
      },
    );
    return filtersSelected;
  }
}
