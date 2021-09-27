import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/buildList.dart';
import 'package:jain_songs/custom_widgets/build_playlistList.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/form_page.dart';
import 'package:jain_songs/services/notification/FirebaseDynamicLinkService.dart';
import 'package:jain_songs/services/notification/FirebaseFCMManager.dart';
import 'package:jain_songs/services/Searchify.dart';
import 'package:jain_songs/services/database/database_controller.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/services/oneSignal_notification.dart';
import 'package:jain_songs/settings_page.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'flutter_list_configured/filter_list.dart';
import 'services/network_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var searchController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  int _currentIndex = 0;
  Timer? _timerLink;

  //This variable is used to determine whether the user searching is found or not.
  KeyboardVisibilityController _keyboardVisibilityController =
      KeyboardVisibilityController();
  // KeyboardVisibilityNotification _keyboardVisibilityNotification =
  //     KeyboardVisibilityNotification();
  bool isBasicSearchEmpty = false;
  bool showProgress = false;
  Widget appBarTitle = ConstWidget.mainAppTitle();

  Icon searchOrCrossIcon = Icon(Icons.search);
  Icon filterIcon = Icon(
    Icons.filter_list_alt,
    color: Colors.indigo,
  );

  SpeechToText speechToText = SpeechToText();
  bool isListening = false;

  void _searchAppBarUi() {
    if (showProgress == false) {
      setState(
        () {
          this.searchOrCrossIcon = ConstWidget.clearIcon;
          this.appBarTitle = TextField(
            textInputAction: TextInputAction.search,
            controller: searchController,
            autofocus: true,
            onChanged: (value) {
              getSongs(value, false);
            },
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.black,
              ),
              hintText: 'Search anything...',
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getSongs('', true);

    FirebaseDynamicLinkService.retrieveInitialDynamicLink(context);
    FirebaseDynamicLinkService.retrieveDynamicLink(context);
    OneSignalNotification().initOneSignal();

    WidgetsBinding.instance!.addObserver(this);

    FirebaseFCMManager.handleFCMRecieved(context);

    // AdManager.initializeFBAds();

    speechToText.initialize(onError: (error) {
      setState(() {
        isListening = false;
        ConstWidget.showSimpleToast(
            context, "Couldn't recognize your words. Please try again!",
            duration: 3);
      });
    }).then((value) {
      setState(() {});
    }).onError((dynamic error, stackTrace) {
      print('Error loading. $error & $stackTrace');
    });

    _keyboardVisibilityController.onChange.listen((isVisible) {
      if (!isVisible &&
          isBasicSearchEmpty &&
          searchController.text.length > 3) {
        isBasicSearchEmpty = false;
        SongSuggestions currentSongSuggestion = SongSuggestions(
          searchController.text,
          "User tried to search this",
        );
        FireStoreHelper().addSuggestions(currentSongSuggestion, []);
      }
    });
  }

  //Here flag determines whether the user is searching within the list or he is querying the whole list for first time.
  //Searching has flag = false.
  void getSongs(String? query, bool flag) async {
    setState(() {
      showProgress = true;
    });

    ListFunctions.filtersSelected.clear();

    if (query != null && flag == false) {
      isBasicSearchEmpty = Searchify().basicSearch(query);
    } else {
      await NetworkHelper().changeDateAndVersion();
      if (Globals.fetchedVersion! > Globals.appVersion) {
        setState(() {
          ConstWidget.showUpdateDialog(context);
        });
      } else {
        bool isSuccess = await DatabaseController()
            .fetchSongs(context, onSqlFetchComplete: refreshSongData);
        if (isSuccess == false) {
          ConstWidget.showSimpleToast(context,
              'Please check your Internet Connection and restart Stavan');
          setState(() {
            showProgress = false;
          });
        }
      }
      ListFunctions().addElementsToList('home');
    }

    setState(() {
      showProgress = false;
    });
  }

  void _filterDialog() async {
    await FilterListDialog.display(context,
        height: 480,
        borderRadius: 20,
        searchFieldHintText: "Search Here", onApplyButtonClick: (list) {
      ListFunctions.filtersSelected = List.from(list);
      setState(() {
        showProgress = true;
      });
      ListFunctions().applyFilter().then((value) {
        setState(() {
          showProgress = false;
        });
      }).catchError((onError) {
        FirebaseCrashlytics.instance
            .log('home_page/_filterDialog(): ' + onError.toString());

        ListFunctions.listToShow = List.from(ListFunctions.sortedSongList);
        ConstWidget.showSimpleToast(
          context,
          'Error applying Filter',
        );
        setState(() {
          showProgress = false;
        });
      });
      Navigator.pop(context);
    },
        //To implement onAllButtonCLick see how onResetButtonClick is made.
        onResetButtonClick: (list) {
      ListFunctions.filtersSelected = List.from(list);
      setState(() {
        showProgress = true;
      });
      ListFunctions().applyFilter().then((value) {
        setState(() {
          showProgress = false;
        });
      }).catchError((onError) {
        FirebaseCrashlytics.instance
            .log('home_page/_filterDialog(): ' + onError.toString());
        ListFunctions.listToShow = List.from(ListFunctions.sortedSongList);
        ConstWidget.showSimpleToast(
          context,
          'Error applying Filter',
        );
        setState(() {
          showProgress = false;
        });
      });
      Navigator.pop(context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _timerLink = Timer(
        Duration(milliseconds: 1000),
        () {
          // print('Lifecycle state resumed');
          FirebaseDynamicLinkService.retrieveDynamicLink(context);
        },
      );
    }
  }

  @override
  void dispose() {
    searchController.clear();
    WidgetsBinding.instance!.removeObserver(this);
    if (_timerLink != null) {
      _timerLink!.cancel();
    }
    // _keyboardVisibilityNotification.dispose();
    super.dispose();
  }

  Future<void> refreshSongData() async {
    print('Refreshing song data');
    bool isSuccess = await DatabaseController().fetchSongsData(context);

    if (isSuccess) {
      print('Refresh success');
      ListFunctions().addElementsToList('home');
      setState(() {});
    } else {
      ConstWidget.showSimpleToast(context, 'Unable to refresh songs');
    }
    print('Refresh Complete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.indigo,
        title: _currentIndex == 0
            ? TextButton(
                onPressed: () {
                  _searchAppBarUi();
                },
                child: appBarTitle,
              )
            : appBarTitle,
        centerTitle: true,
        leading: Transform.scale(
          scale: 0.5,
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                listScrollController.animateTo(
                  listScrollController.position.minScrollExtent,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.fastOutSlowIn,
                );
                ConstWidget.showToast(Globals.welcomeMessage);
              },
              child: Image.asset(
                'images/Logo.png',
                color: Colors.indigo,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          //Search icon and filter icon is hidden when progress is going on.
          Visibility(
            visible: !showProgress,
            child: Row(
              children: [
                Visibility(
                  visible: speechToText.isAvailable && _currentIndex == 0,
                  child: GestureDetector(
                    child: Icon(
                      Icons.mic,
                      color: isListening ? Colors.red : Colors.black,
                    ),
                    onTap: () {
                      if (isListening) {
                        ConstWidget.showSimpleToast(
                            context, 'Stopped Listening.',
                            duration: 2);
                        speechToText.stop().then((value) {
                          setState(() {
                            isListening = false;
                          });
                        });
                      } else {
                        speechToText.listen(onResult: (speechResult) {
                          searchController.text = speechResult.recognizedWords;
                          searchController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: searchController.text.length));
                          setState(() {
                            getSongs(searchController.text, false);
                            isListening = false;
                          });
                        }).onError((dynamic error, stackTrace) {
                          setState(() {
                            isListening = false;
                          });
                        });

                        isListening = true;
                        if (searchOrCrossIcon == ConstWidget.clearIcon) {
                          setState(() {
                            ConstWidget.showSimpleToast(context, 'Listening...',
                                duration: 3);
                          });
                        } else {
                          ConstWidget.showSimpleToast(context, 'Listening...',
                              duration: 3);
                          _searchAppBarUi();
                        }
                      }
                    },
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 25),
                Visibility(
                  visible: _currentIndex == 0,
                  child: GestureDetector(
                    child: searchOrCrossIcon,
                    onTap: () {
                      setState(
                        () {
                          if (this.searchOrCrossIcon.icon == Icons.search) {
                            _searchAppBarUi();
                          } else {
                            if (isListening) {
                              speechToText.stop().then((value) {
                                setState(() {
                                  isListening = false;
                                });
                              });

                              ConstWidget.showSimpleToast(
                                  context, 'Stopped Listening.',
                                  duration: 2);
                            }
                            if (searchController.text.trim().length == 0) {
                              searchOrCrossIcon = Icon(Icons.search);
                              this.appBarTitle = ConstWidget.mainAppTitle();
                              searchController.clear();
                              getSongs('', false);
                            } else {
                              searchController.clear();
                              getSongs('', false);
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 25),
                Visibility(
                  visible: _currentIndex == 0,
                  child: GestureDetector(
                    child: filterIcon,
                    onTap: () {
                      _filterDialog();
                    },
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 25),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: <IconData>[
          FontAwesomeIcons.chartLine,
          Icons.edit_rounded,
          Icons.book_rounded,
          Icons.info_outline_rounded,
        ],
        inactiveColor: Color(0xFF212323),
        splashColor: Colors.indigo,
        iconSize: 30,
        elevation: 5,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.smoothEdge,
        activeColor: ConstWidget.signatureColors(5),
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 1) {
              appBarTitle = Text('');
            } else if (index == 2) {
              appBarTitle = Text('Playlists');
            } else if (index == 3) {
              appBarTitle = Text('Settings and More');
            } else {
              appBarTitle = ConstWidget.mainAppTitle();
              getSongs('', false);
              searchController.clear();
              this.searchOrCrossIcon = Icon(Icons.search);
            }
          });
        },
      ),
      body: <Widget>[
        showProgress
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.indigo,
                  ),
                ),
              )
            : BuildList(
                scrollController: listScrollController,
                searchController: searchController,
              ),
        FormPage(),
        BuildPlaylistList(),
        SettingsPage(),
      ][_currentIndex],
    );
  }
}
