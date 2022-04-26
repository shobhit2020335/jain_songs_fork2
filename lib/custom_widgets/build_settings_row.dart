import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/information_page.dart';
import 'package:jain_songs/services/provider/dark_theme_provider.dart';
import 'package:jain_songs/services/shared_prefs.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/settings_details.dart';
import 'package:jain_songs/services/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuildSettingsRow extends StatefulWidget {
  final SettingsDetails settingsDetails;

  const BuildSettingsRow(this.settingsDetails, {Key? key}) : super(key: key);

  @override
  State<BuildSettingsRow> createState() => _BuildSettingsRowState();
}

class _BuildSettingsRowState extends State<BuildSettingsRow> {
  @override
  Widget build(BuildContext context) {
    DarkThemeProvider themeChange = Provider.of<DarkThemeProvider>(context);
    if (widget.settingsDetails.title.toLowerCase().contains('dark')) {
      widget.settingsDetails.dependentValue = themeChange.isDarkTheme;
    }

    void _toggleAutoPlay(bool newValue) {
      Globals.isVideoAutoPlay = !Globals.isVideoAutoPlay;
      widget.settingsDetails.dependentValue = Globals.isVideoAutoPlay;
      SharedPrefs.setIsAutoplayVideo(Globals.isVideoAutoPlay);
      setState(() {});
    }

    void _toggleDarkMode(bool newValue) {
      widget.settingsDetails.dependentValue = newValue;
      themeChange.setIsDarkTheme(newValue);
      setState(() {});
    }

    void _toggleSetting(bool newValue) {
      if (widget.settingsDetails.title.toLowerCase().contains('autoplay')) {
        _toggleAutoPlay(Globals.isVideoAutoPlay);
      } else if (widget.settingsDetails.title.toLowerCase().contains('dark')) {
        _toggleDarkMode(newValue);
      }
    }

    return ListTileTheme(
      style: ListTileStyle.drawer,
      child: ListTile(
        title: Text(
          widget.settingsDetails.title,
          style: Theme.of(context).primaryTextTheme.bodyText1,
        ),
        subtitle: Text(
          widget.settingsDetails.subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: widget.settingsDetails.isSetting
            ? Switch(
                value: widget.settingsDetails.dependentValue,
                onChanged: _toggleSetting,
                activeColor: ConstWidget.signatureColors(),
              )
            : null,
        onTap: () {
          if (widget.settingsDetails.isSetting == false) {
            if (widget.settingsDetails.title == 'Feedback & Support') {
              Services.sendEmail();
            } else {
              if (Platform.isAndroid) {
                WebView.platform = SurfaceAndroidWebView();
              }
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
            _toggleSetting(widget.settingsDetails.dependentValue);
          }
        },
      ),
    );
  }
}
