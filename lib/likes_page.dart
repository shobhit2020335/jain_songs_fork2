import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/buildRow.dart';
import 'utilities/lists.dart';

//This page is not active but it provides the UI config in Inside playlist branch.
//Merge the inside playlist branch after making UI for playlist pages.

class LikesPage extends StatelessWidget {
  LikesPage() {
    addElementsToList('favourites');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // title: Text('Liked Songs'),
            centerTitle: true,
            pinned: true,
            expandedHeight: 200,
            elevation: 20,
            flexibleSpace: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      'Liked Songs',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.pink[400],
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return BuildRow(
                  currentSong: listToShow[index],
                  color: Colors.pink[400],
                  playlist: playlistList[0],
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
