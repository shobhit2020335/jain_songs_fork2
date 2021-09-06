import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'custom_widgets/build_settingsList.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                      child: ConstWidget.showLogo(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Stavan',
                      style: GoogleFonts.itim(
                        color: Colors.indigo,
                        fontSize: 40,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'v1.3.3',
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
