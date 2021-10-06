import 'package:flutter/material.dart';

class LyricsWidget extends StatelessWidget {
  final String? lyrics;

  LyricsWidget({this.lyrics: 'Lyrics not available at the moment\n'});

  String escapeCharacterIncluded() {
    String formatted = '';
    for (int i = 0; i < this.lyrics!.length; i++) {
      if (this.lyrics![i] == '\\' && this.lyrics![i + 1] == 'n') {
        formatted = formatted + '\n';
        i = i + 1;
      } else {
        formatted = formatted + lyrics![i];
      }
    }
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '\n' + escapeCharacterIncluded(),
      textAlign: TextAlign.center,
      style: Theme.of(context).primaryTextTheme.bodyText2,
    );
  }
}
