import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/services/services.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConstWidget {
  //This card is shown in song page as a whatapp status button
  static Widget statusCard({required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF717075),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 25,
              child: Image.asset(
                'images/almanac_of_wisdom_icon.png',
              ),
            ),
            Text(
              'Read Blogs, Article & More',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }

  static Future<void> showUpdateDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Available'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Newer Version of app is available.',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'Press update to update the app now.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                Services.launchPlayStore(Globals.getAppPlayStoreUrl());
              },
            ),
          ],
        );
      },
    );
  }

  static Icon clearIcon = const Icon(
    Icons.close,
    size: 20,
  );

  static Color? signatureColors({int value = 4}) {
    if (value == 0) {
      return Colors.amber;
    } else if (value == 1) {
      return Colors.pink[300];
    } else if (value == 2) {
      return Colors.green;
    } else if (value == 3) {
      return Colors.redAccent;
    } else {
      return Colors.indigo;
    }
  }

  static Widget showLogo({double scale = 0.6}) {
    return Transform.scale(
        scale: scale,
        child: Image.asset(
          'images/Logo.png',
          color: Globals.isDarkTheme ? Colors.white : Colors.indigo,
        ));
  }

  static void showToast(
    String message, {
    Toast toastLength = Toast.LENGTH_LONG,
    Color toastColor = Colors.indigo,
    Color textColor = Colors.white,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.SNACKBAR,
      textColor: textColor,
      backgroundColor: toastColor,
    );
  }

  static void showSimpleToast(BuildContext context, String message,
      {int duration = 4}) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
      action: SnackBarAction(
        label: 'HIDE',
        onPressed: scaffold.hideCurrentSnackBar,
      ),
    );
    scaffold.showSnackBar(snackBar);
  }

  static Widget mainAppTitle() {
    return Text(
      'Stavan',
      style: GoogleFonts.itim(
        color: Globals.isDarkTheme ? Colors.white : Colors.indigo,
        fontSize: 30,
      ),
    );
  }
}
