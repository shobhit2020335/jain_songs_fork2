import 'package:flutter/material.dart';

class LyricsWidget extends StatelessWidget {
  final String lyrics;

  LyricsWidget({this.lyrics});

  @override
  Widget build(BuildContext context) {
    return Text(
      lyrics,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        color: Color(0xFF18191A),
      ),
    );
  }
}
