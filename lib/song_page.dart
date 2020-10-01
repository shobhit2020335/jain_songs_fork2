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
