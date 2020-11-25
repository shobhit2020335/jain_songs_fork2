import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                      backgroundColor: Colors.black87,
                      child: showLogo(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 40,
                          fontFamily: 'Pacifico',
                          fontWeight: FontWeight.w100,
                        ),
                        children: [
                          TextSpan(
                            text: 'G',
                          ),
                          TextSpan(
                            text: 'E',
                          ),
                          TextSpan(
                            text: 'E',
                          ),
                          TextSpan(
                            text: 'T',
                          ),
                        ],
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
