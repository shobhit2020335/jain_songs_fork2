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

Widget formFieldTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      color: Color(0xFF54BEE6),
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  );
}

Widget formTextFeild(int lines) {
  return Theme(
    data: ThemeData(
      primaryColor: Color(0xFF54BEE6),
    ),
    child: TextField(
      keyboardType: lines == 1 ? TextInputType.name : TextInputType.multiline,
      maxLines: lines,
      style: TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    ),
  );
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
