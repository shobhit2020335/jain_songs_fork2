import 'package:flutter/material.dart';
import 'package:jain_songs/flutter_list_configured/src/search_field_widget.dart';
import 'package:jain_songs/utilities/lists.dart';
import '../filters.dart';
import 'choice_chip_widget.dart';

class FilterListWidget extends StatefulWidget {
  const FilterListWidget(
      {Key? key,
      this.height,
      this.width,
      this.borderRadius = 20,
      this.headlineText = "Select here",
      this.searchFieldHintText = "Search here",
      this.hideSelectedTextCount = false,
      this.hideSearchField = false,
      this.hidecloseIcon = true,
      this.hideHeader = false,
      this.hideheaderText = false,
      this.closeIconColor = Colors.black,
      this.headerTextColor = Colors.black,
      this.applyButonTextColor = Colors.white,
      this.applyButonTextBackgroundColor = Colors.blue,
      this.allResetButonColor = Colors.blue,
      this.selectedTextColor = Colors.white,
      this.backgroundColor = Colors.white,
      this.unselectedTextColor = Colors.black,
      this.searchFieldBackgroundColor = const Color(0xfff5f5f5),
      this.selectedTextBackgroundColor = Colors.blue,
      this.unselectedTextbackGroundColor = const Color(0xfff8f8f8),
      this.onApplyButtonClick,
      /*required*/ required this.onResetButtonClick,
      this.onAllButtonClick})
      : super(key: key);
  final double? height;
  final double? width;
  final double borderRadius;
  final Color closeIconColor;
  final Color headerTextColor;
  final Color backgroundColor;
  final Color applyButonTextColor;
  final Color applyButonTextBackgroundColor;
  final Color allResetButonColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color searchFieldBackgroundColor;
  final Color selectedTextBackgroundColor;
  final Color unselectedTextbackGroundColor;
  final String headlineText;
  final String searchFieldHintText;
  final bool hideSelectedTextCount;
  final bool hideSearchField;
  final bool hidecloseIcon;
  final bool hideHeader;
  final bool hideheaderText;
  final Function(List<Filters>)? onApplyButtonClick;
  final Function(List<Filters>)? onResetButtonClick;
  final Function(List<Filters>)? onAllButtonClick;

  @override
  State<FilterListWidget> createState() => _FilterListWidgetState();
}

class _FilterListWidgetState extends State<FilterListWidget> {
  List<Filters> _selectedTextList = [];
  late List<Filters> _allTextList;

  @override
  void initState() {
    _allTextList = List.from(ListFunctions.filtersAll);
    _selectedTextList = List.from(ListFunctions.filtersSelected);
    super.initState();
  }

  bool showApplyButton = false;

  Widget _body() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            widget.hideHeader ? const SizedBox() : _header(),
            widget.hideSelectedTextCount
                ? const SizedBox(
                    height: 5,
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '${_selectedTextList.length} selected items',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
                child: SingleChildScrollView(
                  // padding: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '   Genre',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        height: 5,
                        color: Colors.indigo,
                      ),
                      Wrap(
                        children: _buildChoiceList(_allTextList, 'genre'),
                      ),
                      const Text(
                        '   Tirthankar',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        height: 5,
                        color: Colors.indigo,
                      ),
                      Wrap(
                        children: _buildChoiceList(_allTextList, 'tirthankar'),
                      ),
                      const Text(
                        '   Category',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        height: 5,
                        color: Colors.indigo,
                      ),
                      Wrap(
                        children: _buildChoiceList(_allTextList, 'category'),
                      ),
                      const Text(
                        '   Language',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        height: 5,
                        color: Colors.indigo,
                      ),
                      Wrap(
                        children: _buildChoiceList(_allTextList, 'language'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
        _controlButon()
      ],
    );
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 15,
            color: Color(0x12000000),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: widget.hideSearchField
                      ? const SizedBox()
                      : SearchFieldWidget(
                          searchFieldBackgroundColor:
                              widget.searchFieldBackgroundColor,
                          searchFieldHintText: widget.searchFieldHintText,
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {}
                              _allTextList = ListFunctions.filtersAll
                                  .where((filter) =>
                                      filter.name.toLowerCase().contains(
                                            value.toLowerCase(),
                                          ))
                                  .toList();
                            });
                          },
                        ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    onTap: () {
                      Navigator.pop(context, null);
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          border: Border.all(color: widget.closeIconColor),
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.close,
                        color: widget.closeIconColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChoiceList(List<Filters> list, String category) {
    List<Widget> choices = [];
    for (var item in list) {
      if (item.category == category) {
        var selectedText = _selectedTextList.contains(item);
        choices.add(
          ChoicechipWidget(
            onSelected: (value) {
              setState(
                () {
                  selectedText
                      ? _selectedTextList.remove(item)
                      : _selectedTextList.add(item);
                },
              );
            },
            selected: selectedText,
            selectedTextColor: widget.selectedTextColor,
            selectedTextBackgroundColor: item.color,
            unselectedTextBackgroundColor: widget.unselectedTextbackGroundColor,
            unselectedTextColor: widget.unselectedTextColor,
            text: item.name,
          ),
        );
      }
    }
    choices.add(
      SizedBox(
        height: 10,
        width: MediaQuery.of(context).size.width,
      ),
    );
    return choices;
  }

  Widget _controlButon() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width * .9,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            const Expanded(child: SizedBox()),
            Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 15,
                    color: Color(0x12000000),
                  )
                ],
              ),
              child: Row(
                children: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(
                        () {
                          _selectedTextList = List.from(_allTextList);
                        },
                      );
                    },
                    child: Container(
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'All',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontSize: 20, color: widget.allResetButonColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedTextList.clear();
                      });
                      if (widget.onResetButtonClick != null) {
                        widget.onResetButtonClick!(_selectedTextList);
                      } else {
                        Navigator.pop(context, _selectedTextList);
                      }
                    },
                    child: Container(
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Reset',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontSize: 20, color: widget.allResetButonColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: widget.applyButonTextBackgroundColor,
                    padding: const EdgeInsets.only(bottom: 5),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Center(
                      child: Text(
                        'Apply',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontSize: 20,
                                color: widget.applyButonTextColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onPressed: () {
                      if (widget.onApplyButtonClick != null) {
                        widget.onApplyButtonClick!(_selectedTextList);
                      } else {
                        Navigator.pop(context, _selectedTextList);
                      }
                    },
                  )
                ],
              ),
            ),

            /// add Bottom space in list
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        child: Container(
          height: widget.height,
          width: widget.width,
          color: widget.backgroundColor,
          child: Stack(
            children: <Widget>[
              _body(),
            ],
          ),
        ),
      ),
    );
  }
}
