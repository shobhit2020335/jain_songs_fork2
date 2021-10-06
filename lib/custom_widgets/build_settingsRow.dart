import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/information_page.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/settings_details.dart';
import 'package:jain_songs/services/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuildSettingsRow extends StatefulWidget {
  final SettingsDetails settingsDetails;

  BuildSettingsRow(this.settingsDetails);

  @override
  State<BuildSettingsRow> createState() => _BuildSettingsRowState();
}

class _BuildSettingsRowState extends State<BuildSettingsRow> {
  void _toggleAutoPlay(bool now) {
    setState(() {
      Globals.isVideoAutoPlay = !Globals.isVideoAutoPlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      style: ListTileStyle.drawer,
      child: ListTile(
        title: Text(
          widget.settingsDetails.title,
          style: Theme.of(context).primaryTextTheme.bodyText1,
        ),
        subtitle: Text(
          widget.settingsDetails.subtitle,
          style: TextStyle(color: Colors.grey),
        ),
        trailing: widget.settingsDetails.isSetting
            ? Switch(
                value: Globals.isVideoAutoPlay,
                onChanged: _toggleAutoPlay,
                activeColor: ConstWidget.signatureColors(),
              )
            : null,
        onTap: () {
          if (widget.settingsDetails.isSetting == false) {
            if (widget.settingsDetails.title == 'Feedback & Support') {
              Services.sendEmail();
            } else {
              if (Platform.isAndroid)
                WebView.platform = SurfaceAndroidWebView();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InformationPage(
                    widget.settingsDetails,
                  ),
                ),
              );
            }
          } else {
            _toggleAutoPlay(Globals.isVideoAutoPlay);
          }
        },
      ),
    );
  }
}
