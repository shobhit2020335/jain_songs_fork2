import 'package:flutter/material.dart';

class LyricsWidget extends StatelessWidget {
  final String lyrics;

  LyricsWidget({this.lyrics});

  String escapeCharacterIncluded() {
    String formatted = '';
    for (int i = 0; i < this.lyrics.length; i++) {
      if (this.lyrics[i] == '\\' && this.lyrics[i + 1] == 'n') {
        formatted = formatted + '\n';
        i = i + 1;
      } else {
        formatted = formatted + lyrics[i];
      }
    }
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      escapeCharacterIncluded(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        color: Color(0xFF18191A),
      ),
    );
  }
}
