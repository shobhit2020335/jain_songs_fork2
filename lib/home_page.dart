import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/buildList.dart';
import 'package:jain_songs/custom_widgets/build_playlistList.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/form_page.dart';
import 'package:jain_songs/searchEmpty_page.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/settings_page.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:translator/translator.dart';
import 'flutter_list_configured/filter_list.dart';
import 'services/network_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var searchController = TextEditingController();
  int _currentIndex = 0;

  //This variable is used to determine whether the user searching is found or not.
  bool isSearchEmpty = false;
  bool showProgress = false;
  Widget appBarTitle = mainAppTitle();

  Icon searchOrCrossIcon = Icon(Icons.search);
  Icon filterIcon = Icon(
    Icons.filter_list_alt,
    color: Colors.indigo,
  );

  //Here flag determines whether the user is searching within the list or he is querying the whole list for first time.
  //Searching has flag = false.
  void getSongs(String query, bool flag) async {
    setState(() {
      showProgress = true;
    });

    filtersSelected.clear();

    if (query != null && flag == false) {
      searchInList(query);
      //This if condition takes care when list become empty and convert the languages and check.
      //TODO: This do not work perfectly. It has to be changed.
      if (listToShow.isEmpty) {
        bool checkNet = await NetworkHelper().checkNetworkConnection();
        if (checkNet == true) {
          GoogleTranslator translator = GoogleTranslator();
          var queryInHindi =
              await translator.translate(query, from: 'en', to: 'hi');
          searchInList(queryInHindi.toString());
          if (listToShow.isEmpty) {
            translator = GoogleTranslator();
            var queryInEnglish =
                await translator.translate(query, from: 'hi', to: 'en');
            searchInList(queryInEnglish.toString());
          }
        }
      }

      if (listToShow.isEmpty && query.length > 2) {
        setState(() {
          isSearchEmpty = true;
        });
      } else {
        isSearchEmpty = false;
      }
    } else {
      await NetworkHelper().changeDateAndVersion();
      if (fetchedVersion > appVersion) {
        setState(() {
          showUpdateDialog(context);
        });
      }
      if (totalDays > fetchedDays) {
        fetchedDays = totalDays;
        FirebaseCrashlytics.instance.log('Ghusa in Daily update on $todayDate');
        await FireStoreHelper().dailyUpdate();
      }
      await FireStoreHelper().getSongs();
      addElementsToList('home');
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
      filtersSelected = List.from(list);
      setState(() {
        showProgress = true;
      });
      applyFilter().then((value) {
        setState(() {
          showProgress = false;
        });
      }).catchError((onError) {
        FirebaseCrashlytics.instance
            .log('home_page/_filterDialog(): ' + onError.toString());
        listToShow = List.from(sortedSongList);
        showToast(context, 'Error applying Filter');
        setState(() {
          showProgress = false;
        });
      });
      Navigator.pop(context);
    },
        //To implement onAllButtonCLick see how onResetButtonClick is made.
        onResetButtonClick: (list) {
      filtersSelected = List.from(list);
      setState(() {
        showProgress = true;
      });
      applyFilter().then((value) {
        setState(() {
          showProgress = false;
        });
      }).catchError((onError) {
        FirebaseCrashlytics.instance
            .log('home_page/_filterDialog(): ' + onError.toString());
        listToShow = List.from(sortedSongList);
        showToast(context, 'Error applying Filter');
        setState(() {
          showProgress = false;
        });
      });
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    getSongs('', true);
  }

  @override
  void dispose() {
    searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? TextButton(
                onPressed: () {
                  setState(() {
                    this.searchOrCrossIcon = Icon(Icons.close);
                    this.appBarTitle = TextField(
                      controller: searchController,
                      //use focus node if autofoucs is not working.
                      autofocus: true,
                      onChanged: (value) {
                        getSongs(value, false);
                      },
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        hintText: 'Search anything...',
                      ),
                    );
                  });
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
                showToast(context, 'Jai Jinendra');
              },
              child: Image.asset(
                'images/Logo.png',
                color: Colors.indigo,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              _currentIndex == 0
                  ? IconButton(
                      icon: searchOrCrossIcon,
                      onPressed: () {
                        setState(() {
                          if (this.searchOrCrossIcon.icon == Icons.search) {
                            this.searchOrCrossIcon = Icon(Icons.close);
                            this.appBarTitle = TextField(
                              controller: searchController,
                              //use focus node if autofoucs is not working.
                              autofocus: true,
                              onChanged: (value) {
                                getSongs(value, false);
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                hintText: 'Search anything...',
                              ),
                            );
                          } else {
                            searchOrCrossIcon = Icon(Icons.search);
                            this.appBarTitle = mainAppTitle();
                            searchController.clear();
                            //Below line is for refresh when cross is clicked.
                            //I am removing this feature, can be enabled later.
                            // getSongs('', true);
                            getSongs('', false);
                          }
                        });
                      })
                  : Icon(null),
              _currentIndex == 0
                  ? IconButton(
                      icon: filterIcon,
                      onPressed: () {
                        _filterDialog();
                      })
                  : Icon(null),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartLine),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.edit),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.archive),
            label: 'Playlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.wrench),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Color(0xFF54BEE6),
        unselectedItemColor: Color(0xFF212323),
        currentIndex: _currentIndex,
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
              appBarTitle = mainAppTitle();
              getSongs('', false);
              searchController.clear();
              this.searchOrCrossIcon = Icon(Icons.search);
            }
          });
        },
      ),
      //Disabling IndexedStack- use to store state of its children here used for bottom navigation's children.
      body: <Widget>[
        Column(
          children: <Widget>[
            isSearchEmpty == false
                ? BuildList(showProgress: showProgress)
                : SearchEmpty(searchController),
          ],
        ),
        FormPage(),
        BuildPlaylistList(),
        SettingsPage(),
      ][_currentIndex],
    );
  }
}

// IndexedStack(
//         index: _currentIndex,
//         children: <Widget>[
//           BuildList(showProgress: showProgress),
//           FormPage(),
//           BuildPlaylistList(),
//           SettingsPage(),
//         ],
//       ),
