import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/build_list.dart';
import 'package:jain_songs/custom_widgets/build_playlist_list.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/form_page.dart';
import 'package:jain_songs/services/notification/firebase_dynamic_link_service.dart';
import 'package:jain_songs/services/notification/firebase_fcm_manager.dart';
import 'package:jain_songs/services/notification/one_signal_notification.dart';
import 'package:jain_songs/services/searchify.dart';
import 'package:jain_songs/services/database/database_controller.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/settings_page.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'flutter_list_configured/filter_list.dart';
import 'services/network_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var searchController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  int _currentIndex = 0;
  Timer? _timerLink;

  //This variable is used to determine whether the user searching is found or not.
  final KeyboardVisibilityController _keyboardVisibilityController =
      KeyboardVisibilityController();
  bool isBasicSearchEmpty = false;
  bool showProgress = false;
  Widget appBarTitle = ConstWidget.mainAppTitle();

  Icon searchOrCrossIcon = const Icon(Icons.search);
  Icon filterIcon = Icon(
    Icons.filter_list_alt,
    color: ConstWidget.signatureColors(),
  );

  SpeechToText speechToText = SpeechToText();
  bool isListening = false;

  void _searchAppBarUi() {
    if (showProgress == false) {
      setState(
        () {
          searchOrCrossIcon = ConstWidget.clearIcon;
          appBarTitle = TextField(
            textInputAction: TextInputAction.search,
            controller: searchController,
            autofocus: true,
            cursorColor: Theme.of(context).primaryColor,
            onChanged: (value) {
              getSongs(value, false);

              listScrollController.animateTo(
                listScrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).appBarTheme.iconTheme?.color,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
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

    WidgetsBinding.instance.addObserver(this);

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
      debugPrint('Error loading. $error & $stackTrace');
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
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor!,
        unselectedTextColor: Theme.of(context).primaryColorLight,
        searchFieldBackgroundColor:
            Theme.of(context).progressIndicatorTheme.color!,
        unselectedTextbackGroundColor:
            Theme.of(context).progressIndicatorTheme.color!,
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
        const Duration(milliseconds: 1000),
        () {
          // debugPrint('Lifecycle state resumed');
          FirebaseDynamicLinkService.retrieveDynamicLink(context);
        },
      );
    }
  }

  @override
  void dispose() {
    searchController.clear();
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink!.cancel();
    }
    // _keyboardVisibilityNotification.dispose();
    super.dispose();
  }

  Future<void> refreshSongData() async {
    debugPrint('Refreshing song data');
    bool isSuccess = await DatabaseController().fetchSongsData(context);

    if (isSuccess) {
      debugPrint('Refresh success');
      ListFunctions().addElementsToList('home');
      setState(() {});
    } else {
      ConstWidget.showSimpleToast(context, 'Unable to refresh songs');
    }
    debugPrint('Refresh Complete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Theme.of(context).primaryColor,
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
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastOutSlowIn,
                );
                ConstWidget.showToast(Globals.welcomeMessage);
              },
              child: Image.asset(
                'images/Logo.png',
                color: Theme.of(context).primaryColor,
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
                      color: isListening
                          ? Colors.red
                          : Theme.of(context).appBarTheme.iconTheme?.color,
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
                          if (searchOrCrossIcon.icon == Icons.search) {
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
                            if (searchController.text.trim().isEmpty) {
                              searchOrCrossIcon = const Icon(Icons.search);
                              appBarTitle = ConstWidget.mainAppTitle();
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
        icons: const <IconData>[
          FontAwesomeIcons.chartLine,
          Icons.edit_rounded,
          Icons.book_rounded,
          Icons.info_outline_rounded,
        ],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        inactiveColor: Theme.of(context).primaryColorLight,
        activeColor: ConstWidget.signatureColors(),
        splashColor: ConstWidget.signatureColors(),
        iconSize: 30,
        elevation: 5,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 1) {
              appBarTitle = const Text('');
            } else if (index == 2) {
              appBarTitle = const Text(
                'Playlists',
              );
            } else if (index == 3) {
              appBarTitle = const Text(
                'Settings and More',
              );
            } else {
              appBarTitle = ConstWidget.mainAppTitle();
              getSongs('', false);
              searchController.clear();
              searchOrCrossIcon = const Icon(Icons.search);
            }
          });
        },
      ),
      body: <Widget>[
        showProgress
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : BuildList(
                scrollController: listScrollController,
                searchController: searchController,
              ),
        const FormPage(),
        const BuildPlaylistList(),
        const SettingsPage(),
      ][_currentIndex],
    );
  }
}
