import 'package:flutter/material.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'build_settings_row.dart';

class BuildSettingsList extends StatelessWidget {
  const BuildSettingsList({Key? key}) : super(key: key);

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
