import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'song_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //TODO: Set the selectedindex to 2 when the user is offline.
  int _currentIndex = 0;

  final _suggestions = <String>[
    'Bhakti Ki Hai Raat',
    'Mukti Poori Ke',
    'Manushya Janam Anmol Re',
    'dkjflkdaa asfasfa ',
    'Bhakti Ki Hai Raat',
    'Mukti Poori Ke',
    'Manushya Janam Anmol Re',
    'Poonie Pagal Hai',
    'dkjflkdaa asfasfa '
        'Bhakti Ki Hai Raat',
    'Mukti Poori Ke',
    'Manushya Janam Anmol Re',
    'Poonie Pagal Hai',
    'dkjflkdaa asfasfa '
  ];

  Widget _buildRow(String name) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongPage(),
          ),
        );
      },
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(color: Color(0xFF212323)),
        ),
        subtitle: Text('Tum Hi Ho'),
        trailing: Icon(
          FontAwesomeIcons.heart,
          //color: Color(0xFF54BEE6),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        itemCount: _suggestions.length,
        itemBuilder: /*1*/ (context, i) {
          return _buildRow(_suggestions[i]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jain Songs',
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.archive),
            title: Text('Stored'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.wrench),
            title: Text('Settings'),
          ),
        ],
        selectedItemColor: Color(0xFF54BEE6),
        unselectedItemColor: Color(0xFF212323),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: <Widget>[
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
        _buildSuggestions(),
        Container(
          child: Center(
            child: SizedBox(
              child: Center(
                child: Text(
                  'Press3',
                  style: TextStyle(color: Colors.black),
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
                child: Text(
                  'Press4',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              height: 50,
              width: 80,
            ),
          ),
        ),
      ][_currentIndex],
    );
  }
}
