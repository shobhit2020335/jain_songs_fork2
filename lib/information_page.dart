import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/utilities/settings_details.dart';

//TODO: Think about feedback page.
//TODO:
class InformationPage extends StatelessWidget {
  final SettingsDetails settingsDetails;

  InformationPage(this.settingsDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(settingsDetails.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.black,
                      child: showLogo(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Pacifico',
                          fontWeight: FontWeight.w100,
                        ),
                        children: [
                          TextSpan(
                            text: 'G',
                            style: TextStyle(color: Colors.pink[300]),
                          ),
                          TextSpan(
                            text: 'E',
                            style: TextStyle(color: Colors.green),
                          ),
                          TextSpan(
                            text: 'E',
                            style: TextStyle(color: Colors.amber),
                          ),
                          TextSpan(
                            text: 'T',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  settingsDetails.subtitle,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20,
                ),
                //This Text is main information text.
                Text(
                  settingsDetails.information,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
