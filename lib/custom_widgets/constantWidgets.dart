import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  final scaffold = Scaffold.of(context);
  final snackBar = SnackBar(
    content: Text(message),
    action:
        SnackBarAction(label: 'HIDE', onPressed: scaffold.hideCurrentSnackBar),
  );
  scaffold.showSnackBar(snackBar);
}
