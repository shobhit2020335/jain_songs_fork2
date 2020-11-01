import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/buildList.dart';

class LikesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liked Songs',
        ),
      ),
      body: BuildList(
        showProgress: false,
        colorRowIcon: Colors.pink[400],
      ),
    );
  }
}
