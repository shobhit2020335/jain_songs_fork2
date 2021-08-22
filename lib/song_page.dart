import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jain_songs/ads/ad_manager.dart';
import 'package:jain_songs/custom_widgets/lyrics_widget.dart';
import 'package:jain_songs/services/Suggester.dart';
import 'package:jain_songs/services/database/database_controlller.dart';
import 'package:jain_songs/services/launch_otherApp.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/youtube_player_configured/src/player/youtube_player.dart';
import 'package:jain_songs/youtube_player_configured/src/utils/youtube_player_controller.dart';
import 'package:jain_songs/youtube_player_configured/src/utils/youtube_player_flags.dart';
import 'custom_widgets/constantWidgets.dart';
import 'services/database/firestore_helper.dart';

class SongPage extends StatefulWidget {
  final String? codeFromDynamicLink;
  final SongDetails? currentSong;
  final PlaylistDetails? playlist;
  final Suggester? suggester;
  final String suggestionStreak;

  SongPage(
      {this.currentSong,
      this.codeFromDynamicLink,
      this.playlist,
      this.suggester,
      required this.suggestionStreak});

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  SongDetails? currentSong;
  bool showProgress = true;
  Timer? _timerLink;
  InterstitialAd? _interstitialAd;

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

  //This is for admob to understand the content in the app. Two more arguements
  //are there but i have not updated them.
  AdRequest adRequest = AdRequest(
    keywords: ['song', 'interstitial'],
  );

  Future<void> _createInterstitialAd() async {
    await InterstitialAd.load(
      //TODO: Change this to test when debugging and vice versa.
      adUnitId: AdManager().songPageinterstitialId,
      request: adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad Ad Loaded');
          _interstitialAd = ad;
          //show ad is called just after the ad is loaded.
          _showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          // print('Interstitial ad load failed: $error');
          _interstitialAd = null;
          //TODO: Can add recursive function to load ad again when failed,
          //see admob flutter pub dev for this.
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      // print('Null interstital Ad while showing');
      return;
    }
    //TODO: Can again load ad after it is dismissed or failed.
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('Ad onShowedFullScreenContent'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad Ad onDismissedFullScreenContent');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError e) {
        print('$ad Ad onAdFailedFullScreenContent: $e');
        ad.dispose();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void setUpSongDetails() async {
    setState(() {
      showProgress = true;
    });

    if (ListFunctions.songsVisited.contains(currentSong!.code) == false) {
      ListFunctions.songsVisited.add(currentSong!.code);
      //TODO: Comment while debugging.
      DatabaseController().changeClicks(context, currentSong!);
    }

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

  Future<void> loadScreen() async {
    //Below code is for admob interstitial ads.
    _createInterstitialAd();

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
          autoPlay: true,
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
        if (ListFunctions.songList.isNotEmpty) {
          currentSong = ListFunctions.songList.firstWhere((song) {
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
          _timerLink?.cancel();
          _timerLink = Timer(Duration(milliseconds: 3000), () {
            if (ListFunctions.songList.isNotEmpty) {
              currentSong = ListFunctions.songList.firstWhere((song) {
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
      _youtubePlayerController?.dispose();
    }
    if (_interstitialAd != null) {
      _interstitialAd?.dispose();
    }
    if (_timerLink != null) {
      _timerLink?.cancel();
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
                            if (widget.suggestionStreak.characters.last
                                .contains(RegExp(r'[0-9]'))) {
                              FireStoreHelper().storeSuggesterStreak(
                                  '${currentSong?.code}',
                                  '${widget.suggestionStreak}');
                            }
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
                              DatabaseController()
                                  .changeLikes(context, currentSong!, -1)
                                  .then((value) {
                                setState(() {});
                              });
                            } else {
                              currentSong!.isLiked = true;
                              setState(() {});
                              DatabaseController()
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
                                    onEnded: (youtubeMetaData) {
                                      showSimpleToast(
                                          context, 'Playing next in 7 seconds',
                                          duration: 7);
                                      _timerLink?.cancel();
                                      _timerLink = Timer(
                                          Duration(milliseconds: 8000), () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return WillPopScope(
                                              onWillPop: () async {
                                                // print(
                                                //     'Automatically changed onwillpop: ${widget.suggestionStreak}0');
                                                FireStoreHelper()
                                                    .storeSuggesterStreak(
                                                        '${currentSong?.code}',
                                                        '${widget.suggestionStreak}1');
                                                return true;
                                              },
                                              child: SongPage(
                                                currentSong: suggester!
                                                    .suggestedSongs[0],
                                                suggester: suggester,
                                                suggestionStreak:
                                                    widget.suggestionStreak +
                                                        '1',
                                              ),
                                            );
                                          }),
                                        );
                                      });
                                    },
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
                                      DatabaseController()
                                          .changeLikes(
                                              context, currentSong!, -1)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    } else {
                                      currentSong!.isLiked = true;
                                      setState(() {});
                                      DatabaseController()
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

                                    DatabaseController()
                                        .changeShare(context, currentSong!)
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

                                          DatabaseController()
                                              .changeShare(
                                                  context, currentSong!)
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
          MaterialPageRoute(builder: (context) {
            return WillPopScope(
              onWillPop: () async {
                // print(
                //     'selected another suggestion onwillpop: ${widget.suggestionStreak}$index');
                FireStoreHelper().storeSuggesterStreak('${currentSong?.code}',
                    '${widget.suggestionStreak}${index + 1}');
                return true;
              },
              child: SongPage(
                currentSong: suggester!.suggestedSongs[index],
                suggester: suggester,
                suggestionStreak: widget.suggestionStreak + '$index+1',
              ),
            );
          }),
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
                'images/suggestion${index + 1}.jpg',
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
