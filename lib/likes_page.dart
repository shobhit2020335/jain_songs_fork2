import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/buildRow.dart';
import 'utilities/lists.dart';

class LikesPage extends StatelessWidget {
  LikesPage() {
    addElementsToList(Colors.pink[400]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Liked Songs'),
            floating: true,
            expandedHeight: 200,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return BuildRow(
                  currentSong: listToShow[index],
                  color: Colors.pink[400],
                );
              },
              childCount: listToShow.length,
            ),
          ),
        ],
      ),
    );
  }
}
