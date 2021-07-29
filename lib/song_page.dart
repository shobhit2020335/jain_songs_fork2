import 'dart:async';
import 'dart:ui';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/ads/ad_manager.dart';
import 'package:jain_songs/custom_widgets/lyrics_widget.dart';
import 'package:jain_songs/services/Suggester.dart';
import 'package:jain_songs/services/launch_otherApp.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/youtube_player_configured/src/player/youtube_player.dart';
import 'package:jain_songs/youtube_player_configured/src/utils/youtube_player_controller.dart';
import 'package:jain_songs/youtube_player_configured/src/utils/youtube_player_flags.dart';
// import 'package:mopub_flutter/mopub.dart';
// import 'package:mopub_flutter/mopub_interstitial.dart';
import 'custom_widgets/constantWidgets.dart';
import 'services/firestore_helper.dart';

class SongPage extends StatefulWidget {
  final String? codeFromDynamicLink;
  final SongDetails? currentSong;
  final PlaylistDetails? playlist;
  final Suggester? suggester;
  // final MoPubInterstitialAd interstitialAd;

  SongPage(
      {this.currentSong,
      this.codeFromDynamicLink,
      this.playlist,
      this.suggester});

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  // InterstitialAd _interstitialAd;
  SongDetails? currentSong;
  bool showProgress = true;
  Timer? _timerLink;

  //Variable for suggestion, it initializes only when a song is opened from out.
  Suggester? suggester;

  //Variable to determine which language is displayed now.
  int langNo = 1;
  int noOfLang = 1;
  bool isSharedNow = false;
  TextOverflow showTextDetails = TextOverflow.ellipsis;

  //Variable to determine whether link is available/net is connected.
  bool isLinkAvail = true;

  //Info to be displayed if net is not on/link is not available.
  String linkInfo = '';
  YoutubePlayerController? _youtubePlayerController;

  // void _loadAdmobInterstitialAd() {
  //   _interstitialAd = _interstitialAd
  //     ..load()
  //     ..show(
  //       anchorType: AnchorType.bottom,
  //       anchorOffset: 0.0,
  //       horizontalCenterOffset: 0.0,
  //     );
  // }

  void setUpSongDetails() async {
    setState(() {
      showProgress = true;
    });

    //Below code is for admob ads.
    // _interstitialAd = InterstitialAd(
    //   adUnitId: AdManager().songPageinterstitialId,
    //   listener: (MobileAdEvent event) {
    //     print("InterstitialAd event is $event");
    //   },
    // );
    // _loadAdmobInterstitialAd();

    if (currentSong!.youTubeLink!.length != null &&
        currentSong!.youTubeLink!.length > 2) {
      await NetworkHelper().checkNetworkConnection().then((value) {
        isLinkAvail = value;
        if (isLinkAvail == false) {
          setState(() {
            linkInfo = 'Please check your Internet Connection!';
          });
        }
      });
      _youtubePlayerController!
          .load(YoutubePlayer.convertUrlToId(currentSong!.youTubeLink!)!);
    } else {
      isLinkAvail = false;
      linkInfo = 'Song not available to listen.';
    }

    if (songsVisited.contains(currentSong!.code) == false) {
      //TODO: Comment while debugging.
      // FireStoreHelper().changeClicks(currentSong);
    }
    songsVisited.add(currentSong!.code);

    langNo = 1;
    noOfLang = 1;
    if (currentSong!.englishLyrics!.length > 2 &&
        currentSong!.englishLyrics != "NA") {
      noOfLang++;
    }
    if (currentSong!.gujaratiLyrics!.length > 2 &&
        currentSong!.gujaratiLyrics != "NA") {
      noOfLang++;
    }
    setState(() {
      showProgress = false;
    });
    suggester!.fetchSuggestions(currentSong!);
  }

  void loadScreen() async {
    if (currentSong!.youTubeLink!.length > 2) {
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
            YoutubePlayer.convertUrlToId(currentSong!.youTubeLink!)!,
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

    setUpSongDetails();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      showProgress = true;
    });
    if (widget.suggester == null && widget.playlist != null) {
      suggester = Suggester(level1: {
        widget.playlist!.playlistTag: widget.playlist!.playlistTagType
      });
    } else if (widget.suggester == null) {
      suggester = Suggester();
    } else {
      suggester = widget.suggester;
    }

    if (widget.codeFromDynamicLink == null ||
        widget.codeFromDynamicLink == '') {
      currentSong = widget.currentSong;
      loadScreen();
    } else {
      _timerLink = Timer(Duration(milliseconds: 3000), () {
        if (songList.isNotEmpty) {
          currentSong = songList.firstWhere((song) {
            return song!.code == widget.codeFromDynamicLink;
          }, orElse: () {
            return null;
          });
          if (currentSong == null) {
            showSimpleToast(context,
                'The link might be incorrect. Try searching for the song.');
            Navigator.of(context).pop();
          } else {
            loadScreen();
          }
        } else {
          _timerLink!.cancel();
          _timerLink = Timer(Duration(milliseconds: 3000), () {
            if (songList.isNotEmpty) {
              currentSong = songList.firstWhere((song) {
                return song!.code == widget.codeFromDynamicLink;
              }, orElse: () {
                return null;
              });
              if (currentSong == null) {
                showSimpleToast(context,
                    'The link might be incorrect. Try searching for the song.');
                Navigator.of(context).pop();
              } else {
                loadScreen();
              }
            } else {
              showSimpleToast(context, 'Internet Connection is slow!');
              Navigator.of(context).pop();
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (_youtubePlayerController != null) {
      _youtubePlayerController!.dispose();
    }
    // if (_interstitialAd != null) {
    //   _interstitialAd.dispose();
    // }
    if (_timerLink != null) {
      _timerLink!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showProgress
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.indigo,
              ),
            )
          : Builder(
              builder: (context) => SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        leading: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.black54,
                          ),
                        ),
                        title: InkWell(
                          onTap: () {
                            setState(() {
                              if (showTextDetails == TextOverflow.ellipsis) {
                                showTextDetails = TextOverflow.clip;
                              } else {
                                showTextDetails = TextOverflow.ellipsis;
                              }
                            });
                          },
                          child: Text(
                            '${currentSong!.songNameEnglish}',
                            style: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        subtitle: InkWell(
                          onTap: () {
                            setState(() {
                              if (showTextDetails == TextOverflow.ellipsis) {
                                showTextDetails = TextOverflow.clip;
                              } else {
                                showTextDetails = TextOverflow.ellipsis;
                              }
                            });
                          },
                          child: Text(
                            '${currentSong!.songInfo}',
                            overflow: showTextDetails,
                            style: GoogleFonts.lato(),
                          ),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            if (currentSong!.isLiked == true) {
                              currentSong!.isLiked = false;
                              setState(() {});
                              FireStoreHelper fireStoreHelper =
                                  FireStoreHelper();
                              fireStoreHelper
                                  .changeLikes(context, currentSong!, -1)
                                  .then((value) {
                                setState(() {});
                              });
                            } else {
                              currentSong!.isLiked = true;
                              setState(() {});
                              FireStoreHelper fireStoreHelper =
                                  FireStoreHelper();
                              fireStoreHelper
                                  .changeLikes(context, currentSong!, 1)
                                  .then((value) {
                                setState(() {});
                              });
                            }
                          },
                          child: Icon(
                            currentSong!.isLiked == true
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            isLinkAvail
                                ? YoutubePlayer(
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    controller: _youtubePlayerController!,
                                    showVideoProgressIndicator: true,
                                    progressIndicatorColor: Colors.indigo,
                                    liveUIColor: Colors.indigo,
                                  )
                                : Text(
                                    linkInfo,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    if (currentSong!.isLiked == true) {
                                      currentSong!.isLiked = false;
                                      setState(() {});
                                      FireStoreHelper fireStoreHelper =
                                          FireStoreHelper();
                                      fireStoreHelper
                                          .changeLikes(
                                              context, currentSong!, -1)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    } else {
                                      currentSong!.isLiked = true;
                                      setState(() {});
                                      FireStoreHelper fireStoreHelper =
                                          FireStoreHelper();
                                      fireStoreHelper
                                          .changeLikes(context, currentSong!, 1)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.favorite_rounded,
                                        color: currentSong!.isLiked == true
                                            ? Colors.pink
                                            : Colors.grey,
                                        size: 19,
                                      ),
                                      Text(
                                        '  ${currentSong!.likes} likes',
                                        style: GoogleFonts.raleway(
                                          color: currentSong!.isLiked == true
                                              ? Colors.pink
                                              : Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 50),
                                InkWell(
                                  onTap: () {
                                    //Opens other app to share song.
                                    shareApp(currentSong?.songNameHindi,
                                        currentSong?.code);

                                    FireStoreHelper fireStoreHelper =
                                        FireStoreHelper();
                                    fireStoreHelper
                                        .changeShare(currentSong!)
                                        .then((value) {
                                      setState(() {});
                                    });
                                    setState(() {
                                      isSharedNow = true;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.share,
                                        color: isSharedNow
                                            ? Colors.pink
                                            : Colors.grey,
                                        size: 19,
                                      ),
                                      Text(
                                        '  ${currentSong!.share} shares',
                                        style: GoogleFonts.raleway(
                                          color: isSharedNow
                                              ? Colors.pink
                                              : Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(),
                              ],
                            ),
                            Divider(thickness: 1),
                            Visibility(
                              visible: suggester!.suggestedSongs.length > 0,
                              child: suggestionBuilder(0),
                            ),
                            Visibility(
                              visible: suggester!.suggestedSongs.length > 1,
                              child: suggestionBuilder(1),
                            ),
                            Visibility(
                              visible: suggester!.suggestedSongs.length > 2,
                              child: suggestionBuilder(2),
                            ),
                            // Divider(thickness: 1),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.blue,
                                    Colors.indigo,
                                  ],
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (noOfLang == 1) {
                                            showSimpleToast(
                                              context,
                                              'No more languages for this song is available now!',
                                            );
                                          } else if (langNo >= noOfLang) {
                                            langNo = 1;
                                          } else if (langNo < noOfLang) {
                                            langNo++;
                                          }
                                          setState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.language,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Language',
                                              style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          //Opens other app to share song.
                                          shareApp(currentSong?.songNameHindi,
                                              currentSong?.code);

                                          FireStoreHelper fireStoreHelper =
                                              FireStoreHelper();
                                          fireStoreHelper
                                              .changeShare(currentSong!)
                                              .then((value) {
                                            setState(() {});
                                          });
                                          setState(() {
                                            isSharedNow = true;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.share,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Share',
                                              style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  LyricsWidget(
                                    lyrics: langNo == 1
                                        ? currentSong!.lyrics
                                        : (langNo == 2
                                            ? currentSong!.englishLyrics
                                            : currentSong!.gujaratiLyrics),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '© ${currentSong!.production!.trim().length > 0 ? currentSong?.production : 'Stavan Co.'}',
                              style: GoogleFonts.lato(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget suggestionBuilder(int index) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SongPage(
              currentSong: suggester!.suggestedSongs[index],
              suggester: suggester,
            ),
          ),
        );
      },
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            YoutubePlayer.getThumbnail(
              videoId: suggester!.suggestedSongs[index]!.youTubeLink!.isNotEmpty
                  ? YoutubePlayer.convertUrlToId(
                      suggester!.suggestedSongs[index]!.youTubeLink!)!
                  : _youtubePlayerController!.initialVideoId,
            ),
            alignment: Alignment.centerLeft,
            width: 60,
            loadingBuilder: (_, child, progress) => progress == null
                ? child
                : Container(
                    color: Colors.white,
                    width: 60,
                    height: 45,
                  ),
            errorBuilder: (context, _, __) => Image.network(
              YoutubePlayer.getThumbnail(
                videoId:
                    suggester!.suggestedSongs[index]!.youTubeLink!.isNotEmpty
                        ? YoutubePlayer.convertUrlToId(
                            suggester!.suggestedSongs[index]!.youTubeLink!)!
                        : _youtubePlayerController!.initialVideoId,
              ),
              width: 60,
              alignment: Alignment.centerLeft,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Container(
                      color: Colors.white,
                      width: 60,
                      height: 45,
                    ),
              errorBuilder: (context, _, __) => Image.asset(
                'images/main.jpg',
                width: 60,
              ),
            ),
          ),
        ),
        title: Text(
          '${suggester!.suggestedSongs[index]!.songNameEnglish}',
          style: GoogleFonts.lato(
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          '${suggester!.suggestedSongs[index]!.songInfo}',
          overflow: showTextDetails,
          style: GoogleFonts.lato(),
        ),
      ),
    );
  }
}
