import 'package:flutter/material.dart';

class SongPage extends StatefulWidget {
  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //TODO: Can underline the text, later.
          'Bhakti Ki Hai Raat',
        ),
      ),
    );
  }
}
