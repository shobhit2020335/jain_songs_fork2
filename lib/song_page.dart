import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      body: SafeArea(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          margin: EdgeInsets.all(10),
          //Background Color of card.
          color: Color(0xFF54BEE6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  //Changes color of arrow when tile is not open.
                  unselectedWidgetColor: Colors.white,
                ),
                child: ExpansionTile(
                  title: Text(
                    'Bhakti Ki Hai Raat',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  children: [
                    Text('Pakau'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 0),
                  color: Color(0xFF7DCFEF),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.heart,
                              color: Colors.white,
                              size: 25,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              '151',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.youtube,
                              color: Colors.white,
                              size: 25,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Listen',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.download,
                              color: Colors.white,
                              size: 25,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Save',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.share,
                              color: Colors.white,
                              size: 25,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              '51',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
