import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/ads/ad_manager.dart';
import 'package:jain_songs/custom_widgets/lyrics_widget.dart';
import 'package:jain_songs/custom_widgets/song_card.dart';
import 'package:jain_songs/services/launch_otherApp.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'custom_widgets/constantWidgets.dart';
import 'services/firestore_helper.dart';

class SongPage extends StatefulWidget {
  final SongDetails currentSong;

  SongPage({this.currentSong});

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  InterstitialAd _interstitialAd;
  bool isHindi = true;

  void _loadInterstitialAd() {
    _interstitialAd = _interstitialAd
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
      );
    isHindi = true;
  }

  @override
  void initState() {
    super.initState();
    _interstitialAd = InterstitialAd(
      //TODO: Change the below id at launch.
      adUnitId: AdManager().songPageinterstitialId,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
    _loadInterstitialAd();
    FireStoreHelper().changeClicks(context, widget.currentSong);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_interstitialAd != null) {
      _interstitialAd.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SongDetails currentSong = widget.currentSong;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentSong.songNameEnglish,
        ),
      ),
      body: Builder(
        builder: (context) => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                SongCard(
                  currentSong: currentSong,
                  likesIcon: currentSong.isLiked == true
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  likesTap: () async {
                    if (currentSong.isLiked == true) {
                      currentSong.isLiked = false;
                      setState(() {});
                      FireStoreHelper fireStoreHelper = FireStoreHelper();
                      await fireStoreHelper.changeLikes(
                          context, currentSong, false);
                    } else {
                      currentSong.isLiked = true;
                      setState(() {});
                      FireStoreHelper fireStoreHelper = FireStoreHelper();
                      await fireStoreHelper.changeLikes(
                          context, currentSong, true);
                    }
                    setState(() {});
                  },
                  shareTap: () async {
                    //Opens other app to share song.
                    shareApp(currentSong.songNameHindi);
                    //Increases likes in FIrebase.
                    FireStoreHelper fireStoreHelper = FireStoreHelper();
                    await fireStoreHelper.changeShare(context, currentSong);
                    setState(() {});
                  },
                  youtubeTap: () {
                    String link = currentSong.youTubeLink;
                    if (link == null || link == '') {
                      showToast(context,
                          'Video URL is not available at this moment!');
                    } else {
                      //TODO: Check playStore link.
                      launchURL(context, link);
                    }
                  },
                  languageTap: () {
                    setState(() {
                      isHindi = !isHindi;
                    });
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
                  lyrics: isHindi ? currentSong.lyrics:currentSong.englishLyrics,
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
