import 'package:flutter/material.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'build_settingsRow.dart';

class BuildSettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ListFunctions.settingsList.length,
      itemBuilder: (context, i) {
        return BuildSettingsRow(
          ListFunctions.settingsList[i],
        );
      },
    );
  }
}
