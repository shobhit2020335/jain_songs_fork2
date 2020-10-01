import 'package:flutter/material.dart';
import 'song_page.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      //TODO: Set the initialindex to 2 when the user is offline.
      length: 3,
      child: new Scaffold(
        backgroundColor: Color(0xFF7DCFEF),
        appBar: new AppBar(
          title: new Text(
            'Jain Songs',
          ),
          //centerTitle: true,
          bottom: new TabBar(
            tabs: <Widget>[
              new Tab(
                text: 'Songs',
              ),
              new Tab(
                text: 'Liked',
              ),
              new Tab(
                text: 'Saved',
              ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            Container(
              child: Center(
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongPage(),
                      ),
                    );
                  },
                  child: SizedBox(
                    child: Center(
                      child: Text('Press'),
                    ),
                    height: 50,
                    width: 80,
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: SizedBox(
                  child: Center(
                    child: Text(
                      'Press2',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  height: 50,
                  width: 80,
                ),
              ),
            ),
            Container(
              child: Center(
                child: SizedBox(
                  child: Center(
                    child: Text('Press3'),
                  ),
                  height: 50,
                  width: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
