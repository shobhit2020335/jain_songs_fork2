import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';

import 'custom_widgets/build_settingsList.dart';

class SettingsPage extends StatelessWidget {
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
