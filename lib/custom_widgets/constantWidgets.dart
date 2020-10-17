import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, {int duration: 4}) {
  final scaffold = Scaffold.of(context);
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: duration),
    action:
        SnackBarAction(label: 'HIDE', onPressed: scaffold.hideCurrentSnackBar),
  );
  scaffold.showSnackBar(snackBar);
}

Widget textBold20(String text) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  );
}

Widget songFunctionIcon(
    {@required IconData icon, String text, Function onPress}) {
  return Column(
    children: [
      GestureDetector(
        // onLongPress: onPress,
        onTap: onPress,
        child: Icon(
          icon,
          color: Colors.white,
          size: 25,
        ),
      ),
      SizedBox(
        height: 8,
      ),
      GestureDetector(
        onTap: onPress,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
