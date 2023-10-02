import 'package:flutter/material.dart';

class LyricsWidget extends StatelessWidget {
  final String? lyrics;

  const LyricsWidget(
      {Key? key, this.lyrics = 'Lyrics not available at the moment\n'})
      : super(key: key);

  String escapeCharacterIncluded() {
    String formatted = '';
    for (int i = 0; i < lyrics!.length; i++) {
      if (lyrics![i] == '\\' && lyrics![i + 1] == 'n') {
        formatted = '$formatted\n';
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
      '\n${escapeCharacterIncluded()}',
      textAlign: TextAlign.center,
      style: Theme.of(context).primaryTextTheme.bodyMedium,
    );
  }
}
