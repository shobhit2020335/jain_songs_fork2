import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'custom_widgets/build_settingsList.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //TODO: Test this color combination.

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
                      child: Icon(
                        FontAwesomeIcons.music,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Geet',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.w100,
                      ),
                    )
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
