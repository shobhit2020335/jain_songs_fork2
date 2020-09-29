import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/lyrics_widget.dart';
import 'package:jain_songs/custom_widgets/song_card.dart';

class SongPage extends StatefulWidget {
  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  int likes = 20;
  int share = 7;
  IconData likesIcon = FontAwesomeIcons.heart;

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: 'HIDE', onPressed: scaffold.hideCurrentSnackBar),
    );
    scaffold.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    //final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      //key: key,
      appBar: AppBar(
        title: Text(
          //TODO: Can underline the text, later.
          'Bhakti Ki Hai Raat',
        ),
      ),
      body: Builder(
        builder: (context) => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                SongCard(
                  songName_English: 'Bhakti Ki Hai Raat',
                  songName_Hindi: 'भक्ति की है रात',
                  singer: 'Harsh Damani',
                  production: 'Shemaroo Entertainment',
                  tirthankar: '',
                  likes: likes,
                  likesIcon: likesIcon,
                  likesTap: () {
                    setState(() {
                      if (likesIcon == FontAwesomeIcons.heart) {
                        likes++;
                        likesIcon = FontAwesomeIcons.solidHeart;
                      } else {
                        likes--;
                        likesIcon = FontAwesomeIcons.heart;
                      }
                    });
                  },
                  share: share,
                  shareTap: () {
                    setState(() {
                      share++;
                    });
                  },
                  youtubeTap: () {
                    _showToast(
                        context, 'Video URL is not available at this moment!');
                  },
                  saveTap: () {
                    _showToast(context, 'Saving lyrics Offline');
                  },
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
                LyricsWidget(
                  lyrics:
                      'भक्ति की है रात दादा आज थाने आणो है\nकाले कोण निभाणो है....भक्ति की है रात....\nदरबार भेरुदेव कैसो सज्यो प्यारो ..\nदयालु आपरो....\nसेवा में दादा सगळा खडा है आज\nहुकुम बस आपरो...\nसेवा में थारी (2)म्हाने आज बिछ जाणो है\nकाले कोण निभाणो है...भक्ति की है रात....\nभक्ति की हे तैयारी भक्ति करां जमकर\nदादा क्यूं देर करो ....\nवादों थारो दादा भक्ति में आणे को\nघणी क्यूं देर करो...\nगीतों सु थाने (2)म्हाने आज रिझाणो है\nकाले कोण निभाणो है....भक्ति की है रात....\nजो कुछ बण्यो मांसु अर्पण दादा सारो\nदादा स्वीकार करो.....\nभक्तों सु गलती होती ही आई है\nदादा ध्यान मत धरो....\nभक्त भेरूजी(2) थारो दास पुराणों है\nकाले कोण निभाणो है.....भक्ति की है रात\n',
                ),
                Text(
                  '-----XXXXX-----',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF18191A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(20),
//                   ),
//                 ),
//                 margin: EdgeInsets.all(10),
//                 //Background Color of card.
//                 color: Color(0xFF54BEE6),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Theme(
//                       data: Theme.of(context).copyWith(
//                         //Changes color of arrow when tile is not open.
//                         unselectedWidgetColor: Colors.white,
//                       ),
//                       child: ExpansionTile(
//                         title: Text(
//                           songName_Hindi,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),
//                         ),
//                         childrenPadding: EdgeInsets.only(
//                           bottom: 10,
//                         ),
//                         children: [
//                           Text('Tirthankar: Mahavir Swami'),
//                           Text('Singer: Harsh Dedhia'),
//                           Text('Production: Sheemaroo Entertainment'),
//                           Text('Original Song: Kora Kagaz'),
//                           Text('Movie: Koi purani movie'),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(15),
//                             topRight: Radius.circular(15),
//                           ),
//                         ),
//                         margin: EdgeInsets.only(bottom: 0),
//                         color: Color(0xFF7DCFEF),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                             top: 10,
//                             bottom: 10,
//                             left: 20,
//                             right: 20,
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Column(
//                                 children: [
//                                   Icon(
//                                     FontAwesomeIcons.heart,
//                                     color: Colors.white,
//                                     size: 25,
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                   Text(
//                                     '151',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: 40,
//                               ),
//                               Column(
//                                 children: [
//                                   Icon(
//                                     FontAwesomeIcons.youtube,
//                                     color: Colors.white,
//                                     size: 25,
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                   Text(
//                                     'Listen',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: 40,
//                               ),
//                               Column(
//                                 children: [
//                                   Icon(
//                                     FontAwesomeIcons.download,
//                                     color: Colors.white,
//                                     size: 25,
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                   Text(
//                                     'Save',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: 40,
//                               ),
//                               Column(
//                                 children: [
//                                   Icon(
//                                     FontAwesomeIcons.share,
//                                     color: Colors.white,
//                                     size: 25,
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                   Text(
//                                     '51',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
