import 'dart:async';
import 'dart:ui';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/ads/ad_manager.dart';
import 'package:jain_songs/custom_widgets/lyrics_widget.dart';
import 'package:jain_songs/custom_widgets/song_card.dart';
import 'package:jain_songs/services/launch_otherApp.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';
// import 'package:mopub_flutter/mopub.dart';
// import 'package:mopub_flutter/mopub_interstitial.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'custom_widgets/constantWidgets.dart';
import 'services/firestore_helper.dart';

class SongPage extends StatefulWidget {
  final String codeFromDynamicLink;
  final SongDetails currentSong;
  // final MoPubInterstitialAd interstitialAd;

  SongPage({this.currentSong, this.codeFromDynamicLink});

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  InterstitialAd _interstitialAd;
  SongDetails currentSong;
  bool showProgress = true;
  Timer _timerLink;

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

  //Uncomment to show mopub ads.
  // void _showMopubInterstitialAd() async {
  //   if (widget.interstitialAd != null) {
  //     await widget.interstitialAd.load();
  //     print('ad loaded');
  //     widget.interstitialAd.show();
  //     print('ad showed');
  //   }
  // }

  void setUpSongDetails() {
    if (songsVisited.contains(currentSong.code) == false) {
      FireStoreHelper().changeClicks(context, currentSong);
    }
    songsVisited.add(currentSong.code);

    if (currentSong.youTubeLink.length != null &&
        currentSong.youTubeLink.length > 2) {
      NetworkHelper().checkNetworkConnection().then((value) {
        isLinkAvail = value;
        if (isLinkAvail == false) {
          setState(() {
            linkInfo = 'Please check your Internet Connection!';
          });
        }
      });
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(currentSong.youTubeLink),
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false,
          useHybridComposition: false,
        ),
      );
    } else {
      isLinkAvail = false;
      linkInfo = 'Song not available to listen.';
    }

    if (currentSong.englishLyrics.length > 2 &&
        currentSong.englishLyrics != "NA") {
      noOfLang++;
    }
    if (currentSong.gujaratiLyrics.length > 2 &&
        currentSong.gujaratiLyrics != "NA") {
      noOfLang++;
    }
    setState(() {
      showProgress = false;
    });
  }

  @override
  void initState() {
    setState(() {
      showProgress = true;
    });
    super.initState();
    //Below code is for admob ads.
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager().songPageinterstitialId,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
    _loadAdmobInterstitialAd();

    //Below code is for mopub ads.
    // _showMopubInterstitialAd();

    if (widget.codeFromDynamicLink == null ||
        widget.codeFromDynamicLink == '') {
      currentSong = widget.currentSong;
      setUpSongDetails();
    } else {
      _timerLink = Timer(Duration(milliseconds: 3000), () {
        if (songList.isNotEmpty) {
          currentSong = songList.firstWhere((song) {
            return song.code == widget.codeFromDynamicLink;
          }, orElse: () {
            return null;
          });
          if (currentSong == null) {
            Navigator.of(context).pop();
          } else {
            setUpSongDetails();
          }
        } else {
          print('Song list is empty in song page');
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void dispose() {
    //TODO: Check below.
    if (_youtubePlayerController != null) {
      _youtubePlayerController.dispose();
    }
    if (_interstitialAd != null) {
      _interstitialAd.dispose();
    }
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentSong != null ? currentSong.songNameEnglish : 'Loading song',
        ),
      ),
      body: showProgress
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.indigo,
              ),
            )
          : Builder(
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
                          shareApp(currentSong.songNameHindi, currentSong.code);

                          FireStoreHelper fireStoreHelper = FireStoreHelper();
                          await fireStoreHelper.changeShare(
                              context, currentSong);
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
