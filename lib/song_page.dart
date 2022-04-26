import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jain_songs/ads/ad_manager.dart';
import 'package:jain_songs/custom_widgets/lyrics_widget.dart';
import 'package:jain_songs/models/user_behaviour_model.dart';
import 'package:jain_songs/services/suggester.dart';
import 'package:jain_songs/services/database/database_controller.dart';
import 'package:jain_songs/services/services.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/youtube_player_configured/youtube_player_flutter.dart';
import 'custom_widgets/constant_widgets.dart';
import 'services/database/firestore_helper.dart';

class SongPage extends StatefulWidget {
  final String? codeFromDynamicLink;
  final SongDetails? currentSong;
  final PlaylistDetails? playlist;
  final Suggester? suggester;
  final String suggestionStreak;
  //Used in user behaviour capture
  final String? userSearched;
  //Dont use it other than user behaviour. Or undertand user behaviour and then use.
  final int postitionInList;

  const SongPage({
    Key? key,
    this.currentSong,
    this.codeFromDynamicLink,
    this.playlist,
    this.suggester,
    required this.suggestionStreak,
    this.userSearched,
    required this.postitionInList,
  }) : super(key: key);

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
  YoutubePlayerController? _youtubePlayerController = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId('https://youtu.be/fHrHhtbQU6w')!);

  //This is for admob to understand the content in the app. Two more arguements
  //are there but i have not updated them.
  AdRequest adRequest = const AdRequest(
    keywords: ['song', 'interstitial'],
  );

  Future<void> _createInterstitialAd() async {
    await InterstitialAd.load(
      //TODO: Change this to test when debugging and vice versa.
      adUnitId: AdManager().songPageinterstitialId,
      request: adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('$ad Ad Loaded');
          _interstitialAd = ad;
          //show ad is called just after the ad is loaded.
          _showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          // debugPrint('Interstitial ad load failed: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      // debugPrint('Null interstital Ad while showing');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          debugPrint('Ad onShowedFullScreenContent'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('$ad Ad onDismissedFullScreenContent');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError e) {
        debugPrint('$ad Ad onAdFailedFullScreenContent: $e');
        ad.dispose();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  //Stores the user behaviour of clicking, suggestoin, playlist, FCM, etc
  Future<void> _storeUserBehaviour() async {
    int clickedAtRank = ListFunctions.songsVisited.length + 1;
    int positionInList = widget.postitionInList;
    String suggestionOpened = '';
    String? playlistTitle = widget.playlist?.title;

    if (widget.codeFromDynamicLink != null) {
      playlistTitle = 'Dynamic Link';
    }

    if (widget.suggester != null) {
      suggestionOpened = 'Suggestion. List: ';
      if (positionInList == -1) {
        suggestionOpened = 'Autoplay Suggestion. List: ';
        positionInList = 0;
      }

      for (int i = 0; i < widget.suggester!.suggestedSongs.length; i++) {
        suggestionOpened += ' ' + widget.suggester!.suggestedSongs[i]!.code!;
      }
    }

    UserBehaviourModel userBehaviourModel = UserBehaviourModel(
      songCode: currentSong!.code!,
      songName: currentSong!.songNameEnglish!,
      userSearched: widget.userSearched,
      suggestionOpened: suggestionOpened,
      playlistOpened: playlistTitle,
      isLiked: currentSong!.isLiked,
      clickedAtRank: clickedAtRank,
      positionInList: widget.postitionInList,
    );

    await FireStoreHelper().storeUserSearchBehaviour(userBehaviourModel);
  }

  void setUpSongDetails() async {
    setState(() {
      showProgress = true;
    });

    //Stores the user behaviour
    _storeUserBehaviour();

    if (ListFunctions.songsVisited.contains(currentSong!.code) == false) {
      ListFunctions.songsVisited.add(currentSong!.code);
      //XXX: Comment while debugging.
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
          autoPlay: Globals.isVideoAutoPlay,
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
      _timerLink = Timer(const Duration(milliseconds: 3000), () {
        if (ListFunctions.songList.isNotEmpty) {
          currentSong = ListFunctions.songList.firstWhere((song) {
            return song!.code == widget.codeFromDynamicLink;
          }, orElse: () {
            return null;
          });
          if (currentSong == null) {
            ConstWidget.showSimpleToast(
              context,
              'Song not found. Restart the App to load the new song and then try again.',
              duration: 5,
            );
            Navigator.of(context).pop();
          } else {
            loadScreen();
          }
        } else {
          _timerLink?.cancel();
          ConstWidget.showSimpleToast(context, 'Loading Song. Please Wait!');
          _timerLink = Timer(const Duration(milliseconds: 10000), () {
            if (ListFunctions.songList.isNotEmpty) {
              currentSong = ListFunctions.songList.firstWhere((song) {
                return song!.code == widget.codeFromDynamicLink;
              }, orElse: () {
                return null;
              });
              if (currentSong == null) {
                ConstWidget.showSimpleToast(
                  context,
                  'Song not found. Restart the App to load the new song and then try again.',
                  duration: 5,
                );
                Navigator.of(context).pop();
              } else {
                loadScreen();
              }
            } else {
              ConstWidget.showSimpleToast(
                  context, 'Internet connection might be slow!');
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

  Future<void> _likeTheSong() async {
    if (currentSong!.isLiked == true) {
      currentSong?.isLiked = false;
      currentSong?.likes = currentSong!.likes! - 1;
      currentSong?.popularity = currentSong!.popularity! - 1;
      setState(() {});
      DatabaseController().changeLikes(context, currentSong!, -1).then((value) {
        if (value == false) {
          debugPrint('Error changing likes');
          currentSong?.isLiked = true;
          currentSong?.likes = currentSong!.likes! + 1;
          currentSong?.popularity = currentSong!.popularity! + 1;
          ConstWidget.showSimpleToast(
              context, 'Error Disliking song! Try again');
        }
        setState(() {});
      });
    } else {
      currentSong?.isLiked = true;
      currentSong?.likes = currentSong!.likes! + 1;
      currentSong?.popularity = currentSong!.popularity! + 1;
      setState(() {});
      DatabaseController().changeLikes(context, currentSong!, 1).then((value) {
        if (value == false) {
          debugPrint('Error changing likes');
          currentSong?.isLiked = false;
          currentSong?.likes = currentSong!.likes! - 1;
          currentSong?.popularity = currentSong!.popularity! - 1;
          ConstWidget.showSimpleToast(context, 'Error Liking song! Try again');
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          width: MediaQuery.of(context).size.width / 1,
          controller: _youtubePlayerController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Theme.of(context).primaryColor,
          liveUIColor: Colors.indigo,
          onEnded: (youtubeMetaData) {
            ConstWidget.showSimpleToast(context, 'Playing next in 7 seconds',
                duration: 7);
            _timerLink?.cancel();
            _timerLink = Timer(const Duration(milliseconds: 8000), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return SongPage(
                    currentSong: suggester!.suggestedSongs[0],
                    suggester: suggester,
                    suggestionStreak: widget.suggestionStreak + '1',
                    postitionInList: -1,
                  );
                }),
              );
            });
          },
        ),
        builder: (context, player) {
          return Scaffold(
            body: showProgress
                ? const Center(
                    child: CircularProgressIndicator(),
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
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                              title: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (showTextDetails ==
                                        TextOverflow.ellipsis) {
                                      showTextDetails = TextOverflow.clip;
                                    } else {
                                      showTextDetails = TextOverflow.ellipsis;
                                    }
                                  });
                                },
                                child: Text(
                                  '${currentSong!.songNameEnglish}',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline2,
                                ),
                              ),
                              subtitle: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (showTextDetails ==
                                        TextOverflow.ellipsis) {
                                      showTextDetails = TextOverflow.clip;
                                    } else {
                                      showTextDetails = TextOverflow.ellipsis;
                                    }
                                  });
                                },
                                child: Text(
                                  currentSong!.songInfo,
                                  overflow: showTextDetails,
                                  style: GoogleFonts.lato(),
                                ),
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  _likeTheSong();
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10),
                                  isLinkAvail
                                      ? player
                                      : Text(
                                          linkInfo,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .subtitle2,
                                        ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      InkWell(
                                        onTap: () {
                                          _likeTheSong();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.favorite_rounded,
                                              color:
                                                  currentSong!.isLiked == true
                                                      ? Colors.pink
                                                      : Colors.grey,
                                              size: 19,
                                            ),
                                            Text(
                                              '  ${currentSong!.likes} likes',
                                              style: GoogleFonts.raleway(
                                                color:
                                                    currentSong!.isLiked == true
                                                        ? Colors.pink
                                                        : Colors.grey,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 50),
                                      InkWell(
                                        onTap: () {
                                          //Opens other app to share song.
                                          Services.shareApp(
                                              currentSong?.songNameHindi,
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
                                      const SizedBox(),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ConstWidget.statusCard(
                                    onTap: () async {
                                      _youtubePlayerController?.pause();
                                      bool isSuccess =
                                          await DatabaseControllerForPosts()
                                              .fetchPostsOfSong(
                                                  currentSong!.code!,
                                                  currentSong!.searchKeywords!);
                                      //TODO: Show some loading here
                                      if (isSuccess &&
                                          ListFunctions
                                              .postsToShow.isNotEmpty) {
                                        debugPrint(
                                            'Posts fetched successfully for a song');
                                        await ConstWidget.showPostsForStatus(
                                            context);
                                      } else {
                                        debugPrint(
                                            'Error fetching posts of a song or empty posts');
                                      }
                                      _youtubePlayerController?.play();
                                    },
                                  ),
                                  const Divider(thickness: 1),
                                  Visibility(
                                    visible:
                                        suggester!.suggestedSongs.isNotEmpty,
                                    child: suggestionBuilder(0),
                                  ),
                                  Visibility(
                                    visible:
                                        suggester!.suggestedSongs.length > 1,
                                    child: suggestionBuilder(1),
                                  ),
                                  Visibility(
                                    visible:
                                        suggester!.suggestedSongs.length > 2,
                                    child: suggestionBuilder(2),
                                  ),
                                  // Divider(thickness: 1),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: const BoxDecoration(
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
                                                  ConstWidget.showSimpleToast(
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
                                                  const Icon(
                                                    FontAwesomeIcons.language,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    'Language',
                                                    style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                //Opens other app to share song.
                                                Services.shareApp(
                                                    currentSong?.songNameHindi,
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
                                                  const Icon(
                                                    FontAwesomeIcons.share,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    'Share',
                                                    style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
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
                                                  : currentSong!
                                                      .gujaratiLyrics),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '© ${currentSong!.production!.trim().isNotEmpty ? currentSong?.production : 'Stavan Co.'}',
                                    style: GoogleFonts.lato(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        });
  }

  Widget suggestionBuilder(int index) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return SongPage(
              currentSong: suggester!.suggestedSongs[index],
              suggester: suggester,
              suggestionStreak: widget.suggestionStreak + '${index + 1}',
              postitionInList: index,
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
          style: Theme.of(context).primaryTextTheme.bodyText1,
        ),
        subtitle: Text(
          suggester!.suggestedSongs[index]!.songInfo,
          overflow: showTextDetails,
          style: GoogleFonts.lato(),
        ),
      ),
    );
  }
}
