import 'package:flutter/material.dart';
import 'package:jain_songs/information_page.dart';
import 'package:jain_songs/utilities/settings_details.dart';
import 'package:jain_songs/services/launch_otherApp.dart';

//TODO: Adding new page for settings.

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
          if (settingsDetails.title == 'Feedback & Support') {
            sendEmail();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InformationPage(
                  settingsDetails,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
