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
        backgroundColor: Colors.white,
        title: Text(
          'Jain Songs',
          style: TextStyle(
            //TODO: Title color can be used teal or it can be made black+teal shade.
            color: Color(0xFF212323),
          ),
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
