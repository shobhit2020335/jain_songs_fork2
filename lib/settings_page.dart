import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'custom_widgets/build_settings_list.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
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
                  'v2.2.0',
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
