import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jain_songs/information_page.dart';
import 'package:jain_songs/utilities/settings_details.dart';
import 'package:jain_songs/services/launch_otherApp.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
            if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
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
