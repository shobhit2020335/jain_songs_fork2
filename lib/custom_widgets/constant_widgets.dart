import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/services/services.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jain_songs/utilities/lists.dart';

class ConstWidget {
  //This card is shown in song page as a whatapp status button
  static Widget statusCard() {
    int advertisementNumber =
        Random().nextInt(ListFunctions.advertisementList.length);

    return InkWell(
      onTap: () {
        Services.launchURL(
          ListFunctions.advertisementList[advertisementNumber].companyURL,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigo),
          color: ListFunctions
              .advertisementList[advertisementNumber].backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage(
                ListFunctions.advertisementList[advertisementNumber].icon,
              ),
              width:
                  ListFunctions.advertisementList[advertisementNumber].iconSize,
              height:
                  ListFunctions.advertisementList[advertisementNumber].iconSize,
              color: ListFunctions
                  .advertisementList[advertisementNumber].iconColor,
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
            ),
            Text(
              ListFunctions.advertisementList[advertisementNumber].title,
              style: GoogleFonts.lato(
                color: ListFunctions
                    .advertisementList[advertisementNumber].textColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: ListFunctions
                  .advertisementList[advertisementNumber].textColor,
              size: 20,
            )
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
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Update Available'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Newer Version of app is available.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Press update button.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  Services.launchURL(Globals.getAppPlayStoreUrl());
                },
              ),
            ],
          ),
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
