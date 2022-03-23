import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'custom_widgets/build_settingsList.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          const Expanded(
            flex: 2,
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
                      backgroundColor: Theme.of(context).primaryColorDark,
                      child: ConstWidget.showLogo(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Stavan',
                      style: GoogleFonts.itim(
                        color: Theme.of(context).primaryColor,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
                Text(
                  'v1.4.0',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
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
