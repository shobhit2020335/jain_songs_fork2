import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:jain_songs/custom_widgets/build_list.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/flutter_list_configured/filter_list.dart';
import 'package:jain_songs/services/Searchify.dart';
import 'package:jain_songs/services/database/database_controller.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/notification/firebase_dynamic_link_service.dart';
import 'package:jain_songs/services/notification/firebase_fcm_manager.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SongsView extends StatefulWidget {
  const SongsView({Key? key}) : super(key: key);

  @override
  State<SongsView> createState() => SongsViewState();
}

class SongsViewState extends State<SongsView>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  var searchController = TextEditingController();
  Widget appBarTitle = ConstWidget.mainAppTitle();
  final ScrollController listScrollController = ScrollController();
  Timer? _timerLink;

  //This variable is used to determine whether the user searching is found or not.
  final KeyboardVisibilityController _keyboardVisibilityController =
      KeyboardVisibilityController();
  bool isBasicSearchEmpty = false;
  bool showProgress = false;

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
    // OneSignalNotification().initOneSignal();

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

  // @override
  // void didChangeDependencies() {
  //   getSongs('', false);
  //   searchController.clear();
  //   super.didChangeDependencies();
  // }

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
        FirebaseCrashlytics.instance.log('home_page/_filterDialog(): $onError');

        ListFunctions.listToShow = List.from(ListFunctions.sortedSongList);
        ConstWidget.showSimpleToast(
          context,
          'Error applying Filter',
        );
        setState(() {
          showProgress = false;
        });
      });
      context.pop();
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
        FirebaseCrashlytics.instance.log('home_page/_filterDialog(): $onError');
        ListFunctions.listToShow = List.from(ListFunctions.sortedSongList);
        ConstWidget.showSimpleToast(
          context,
          'Error applying Filter',
        );
        setState(() {
          showProgress = false;
        });
      });
      context.pop();
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
          title: TextButton(
            onPressed: () {
              _searchAppBarUi();
            },
            child: appBarTitle,
          ),
          centerTitle: true,
          leading: Transform.scale(
            scale: 0.5,
            child: Builder(
              builder: (context) => GestureDetector(
                onTap: () {
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
                  GestureDetector(
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
                  SizedBox(width: MediaQuery.of(context).size.width / 25),
                  GestureDetector(
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
                  SizedBox(width: MediaQuery.of(context).size.width / 25),
                  GestureDetector(
                    child: filterIcon,
                    onTap: () {
                      _filterDialog();
                    },
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 25),
                ],
              ),
            ),
          ],
        ),
        body: showProgress
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : BuildList(
                scrollController: listScrollController,
                searchController: searchController,
              ));
  }

  @override
  bool get wantKeepAlive => false;
}
