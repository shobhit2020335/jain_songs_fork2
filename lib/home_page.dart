import 'package:flutter/material.dart';
import 'song_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jain Songs',
        ),
        centerTitle: true,
      ),
      body: Container(
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
    );
  }
}
