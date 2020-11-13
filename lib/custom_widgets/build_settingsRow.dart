import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/utilities/settings_details.dart';

//TODO: Complete this.

class BuildSettingsRow extends StatelessWidget {
  final SettingsDetails settingsDetails;

  BuildSettingsRow(this.settingsDetails);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      selectedColor: Colors.grey,
      style: ListTileStyle.drawer,
      child: ListTile(
        title: Text(
          settingsDetails.title,
        ),
        subtitle: Text(
          settingsDetails.subtitle,
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {
          // await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => SongPage(currentSong: currentSong),
          //   ),
          // );
        },
      ),
    );
    ;
  }
}
