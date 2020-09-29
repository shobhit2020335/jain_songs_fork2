import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SongPage extends StatefulWidget {
  @override
  _SongPageState createState() => _SongPageState();
}

String songName_English = 'Bhakti Ki Hai Raat';
String songName_Hindi = 'भक्ति की है रात';

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //TODO: Can underline the text, later.
          songName_English,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
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
                          songName_Hindi,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        childrenPadding: EdgeInsets.only(
                          bottom: 10,
                          left: 10,
                        ),
                        children: [
                          Text('Tirthankar: Mahavir Swami'),
                          Text('Singer: Harsh Dedhia'),
                          Text('Production: Sheemaroo Entertainment'),
                          Text('Original Song: Kora Kagaz'),
                          Text('Movie: Koi purani movie'),
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
              SizedBox(
                height: 20,
              ),
              Text(
                'Lyrics',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF18191A),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'भक्ति की है रात दादा आज थाने आणो है\nकाले कोण निभाणो है....भक्ति की है रात....\nदरबार भेरुदेव कैसो सज्यो प्यारो ..\nदयालु आपरो....\nसेवा में दादा सगळा खडा है आज\nहुकुम बस आपरो...\nसेवा में थारी (2)म्हाने आज बिछ जाणो है\nकाले कोण निभाणो है...भक्ति की है रात....\nभक्ति की हे तैयारी भक्ति करां जमकर\nदादा क्यूं देर करो ....\nवादों थारो दादा भक्ति में आणे को\nघणी क्यूं देर करो...\nगीतों सु थाने (2)म्हाने आज रिझाणो है\nकाले कोण निभाणो है....भक्ति की है रात....\nजो कुछ बण्यो मांसु अर्पण दादा सारो\nदादा स्वीकार करो.....\nभक्तों सु गलती होती ही आई है\nदादा ध्यान मत धरो....\nभक्त भेरूजी(2) थारो दास पुराणों है\nकाले कोण निभाणो है.....भक्ति की है रात\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF18191A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
