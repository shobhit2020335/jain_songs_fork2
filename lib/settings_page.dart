import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';

import 'ads/ad_manager.dart';
import 'custom_widgets/build_settingsList.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  BannerAd _bannerAd;

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorOffset: 80);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdManager().settingsNavigationBannerId,
      size: AdSize.banner,
    );

    // TODO: Load a Banner Ad
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: BuildSettingsList(),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      child: showLogo(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'STAVAN',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 40,
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
