import 'package:flutter/material.dart';

Widget showLogo({double scale = 0.6}) {
  return Transform.scale(
      scale: scale,
      child: Image.asset(
        'images/Logo.png',
        color: Colors.indigo,
      ));
}

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
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget formTextField(int lines,
    {String hint, TextEditingController editingController}) {
  return Theme(
    data: ThemeData(
      primaryColor: Colors.black,
    ),
    child: TextField(
      controller: editingController,
      keyboardType: lines == 1 ? TextInputType.name : TextInputType.multiline,
      maxLines: lines,
      style: TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
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
