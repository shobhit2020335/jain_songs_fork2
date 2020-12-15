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
import 'services/network_helper.dart';

//TODO: Crashlytics in detail.
//TODO: Disable ss taking in app.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var searchController = TextEditingController();
  int _currentIndex = 0;
  //This variable is used to determine whether the user searching is found or not.
  bool isSeacrchEmpty = false;
  bool showProgress = false;
  Widget appBarTitle = Text(
    'Jain Songs',
  );

  Icon searchOrCrossIcon = Icon(Icons.search);
  Icon filterIcon = Icon(
    Icons.filter_list_alt,
    color: Colors.white,
  );

  //Here flag determines whether the user is searching within the list or he is querying the whole list for first time.
  //Searching has flag = false.
  void getSongs(String query, bool flag) async {
    setState(() {
      showProgress = true;
    });
    if (query != null && flag == false) {
      searchInList(query);
      //This if condition takes care when list become empty and convert the languages and check.
      //TODO: This do not work perfectly. It has to be changed.
      if (listToShow.isEmpty) {
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

      if (listToShow.isEmpty && query.length > 2) {
        setState(() {
          isSeacrchEmpty = true;
        });
      } else {
        isSeacrchEmpty = false;
      }
    } else {
      await NetworkHelper().changeDate();
      if (totalDays > fetchedDays) {
        fetchedDays = totalDays;
        print('Ghusa in daily update');
        await FireStoreHelper().dailyUpdate();
      }
      await FireStoreHelper().getSongs();
      addElementsToList('home');
    }
    setState(() {
      showProgress = false;
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
        title: appBarTitle,
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
                                hintText: 'Search...',
                              ),
                            );
                          } else {
                            searchOrCrossIcon = Icon(Icons.search);
                            this.appBarTitle = Text('Jain Songs');
                            searchController.clear();
                            //Below line is for refresh when cross is clicked.
                            //I am remvoing this feature, can be enabled later.
                            // getSongs('', true);
                            getSongs('', false);
                          }
                        });
                      })
                  : Icon(null),
              _currentIndex == 0
                  ? IconButton(icon: filterIcon, onPressed: null)
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
              appBarTitle = Text('Jain Songs');
              getSongs('', false);
              this.searchOrCrossIcon = Icon(Icons.search);
            }
          });
        },
      ),
      //TODO: Disabling IndexedStack- use to store state of its children here used for bottom navigation's children.
      body: <Widget>[
        isSeacrchEmpty == false
            ? BuildList(showProgress: showProgress)
            : SearchEmpty(searchController),
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
