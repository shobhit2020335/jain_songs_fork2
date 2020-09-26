import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(MainTheme());

class MainTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.teal,
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'Pacifico',
            color: Colors.white,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
