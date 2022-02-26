import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {
  final String? searchFieldHintText;
  final Color? searchFieldBackgroundColor;
  final Function(String)? onChanged;
  const SearchFieldWidget(
      {Key? key,
      this.searchFieldHintText,
      this.onChanged,
      this.searchFieldBackgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: searchFieldBackgroundColor),
        child: TextField(
          onChanged: onChanged,
          style: TextStyle(
              fontSize: 18, color: Theme.of(context).primaryColorLight),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search,
                color: Theme.of(context).appBarTheme.iconTheme?.color),
            hintText: searchFieldHintText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
