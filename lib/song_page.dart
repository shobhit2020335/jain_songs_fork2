import 'dart:ui';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/ads/ad_manager.dart';
import 'package:jain_songs/custom_widgets/lyrics_widget.dart';
import 'package:jain_songs/custom_widgets/song_card.dart';
import 'package:jain_songs/services/launch_otherApp.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:mopub_flutter/mopub.dart';
import 'package:mopub_flutter/mopub_interstitial.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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

  //Variable to determine which language is displayed now.
  int langNo = 1;
  int noOfLang = 1;

  //Variable to determine whether link is available/net is connected.
  bool isLinkAvail = true;

  //Info to be displayed if net is not on/link is not available.
  String linkInfo = '';
  YoutubePlayerController _youtubePlayerController;

  void _loadAdmobInterstitialAd() {
    _interstitialAd = _interstitialAd
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
      );
  }

  MoPubInterstitialAd interstitialAd;
  void _loadMopubInterstitialAd() async {
    interstitialAd = MoPubInterstitialAd(
      '7e9b62190a1f4a6ab748342e6dd012a6',
      (result, args) {
        print('Interstitial $result');
      },
      reloadOnClosed: true,
    );
    await interstitialAd.load();
    print('ad loaded');
    interstitialAd.show();
    print('ad showed');
  }

  @override
  void initState() {
    super.initState();
    //Below code is for admob ads.
    // _interstitialAd = InterstitialAd(
    //   adUnitId: AdManager().songPageinterstitialId,
    //   listener: (MobileAdEvent event) {
    //     print("InterstitialAd event is $event");
    //   },
    // );
    // _loadAdmobInterstitialAd();

    //Below code is for mopub ads.
    try {
      MoPub.init('7e9b62190a1f4a6ab748342e6dd012a6', testMode: false).then((_) {
        _loadMopubInterstitialAd();
      });
    } on PlatformException {}

    if (songsVisited.contains(widget.currentSong.code) == false) {
      FireStoreHelper().changeClicks(context, widget.currentSong);
    }
    songsVisited.add(widget.currentSong.code);

    if (widget.currentSong.youTubeLink.length != null &&
        widget.currentSong.youTubeLink.length > 2) {
      NetworkHelper().checkNetworkConnection().then((value) {
        isLinkAvail = value;
        if (isLinkAvail == false) {
          setState(() {
            linkInfo = 'Please check your Internet Connection!';
          });
        }
      });
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId:
            YoutubePlayer.convertUrlToId(widget.currentSong.youTubeLink),
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    } else {
      isLinkAvail = false;
      linkInfo = 'Song not available to listen.';
    }

    if (widget.currentSong.englishLyrics.length > 2 &&
        widget.currentSong.englishLyrics != "NA") {
      noOfLang++;
    }
    if (widget.currentSong.gujaratiLyrics.length > 2 &&
        widget.currentSong.gujaratiLyrics != "NA") {
      noOfLang++;
    }
  }

  @override
  void dispose() {
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
                    //Increases likes in Firebase.
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
                      launchURL(context, link);
                      print('Launching');
                    }
                  },
                  languageTap: () {
                    if (noOfLang == 1) {
                      showToast(context,
                          'No more languages for this song is available now!',
                          duration: 2);
                    } else if (langNo >= noOfLang) {
                      langNo = 1;
                    } else if (langNo < noOfLang) {
                      langNo++;
                    }
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                isLinkAvail
                    ? YoutubePlayer(
                        controller: _youtubePlayerController,
                        showVideoProgressIndicator: true,
                        onReady: () {},
                      )
                    : Text(
                        linkInfo,
                        style: TextStyle(
                          color: Colors.grey,
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
                LyricsWidget(
                  lyrics: langNo == 1
                      ? currentSong.lyrics
                      : (langNo == 2
                          ? currentSong.englishLyrics
                          : currentSong.gujaratiLyrics),
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
