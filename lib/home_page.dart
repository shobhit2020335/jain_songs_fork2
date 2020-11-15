import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/buildList.dart';
import 'package:jain_songs/custom_widgets/build_playlistList.dart';
import 'package:jain_songs/form_page.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/settings_page.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'services/network_helper.dart';

//TODO: Crashlytics in detail.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool showProgress = false;
  Widget appBarTitle = Text(
    'Jain Songs',
  );

  Icon searchOrCrossIcon = Icon(Icons.search);
  Icon filterIcon = Icon(
    Icons.filter_list_alt,
    color: Color(0xFF54BEE6),
  );

  void getSongs(String query) async {
    setState(() {
      showProgress = true;
    });
    await NetworkHelper().changeDate();
    if (totalDays > fetchedDays) {
      fetchedDays = totalDays;
      print('Ghusa in daily update');
      await FireStoreHelper().dailyUpdate();
    }
    await FireStoreHelper().getSongs(query);
    setState(() {
      showProgress = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getSongs('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        centerTitle: true,
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
                              //use focus node if autofoucs is not working.
                              autofocus: true,
                              onChanged: (value) {
                                getSongs(value);
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
                            getSongs('');
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
            }
          });
        },
      ),
      //IndexedStack use to store state of its children here used for bottom navigation's children.
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          BuildList(showProgress: showProgress),
          FormPage(),
          BuildPlaylistList(),
          SettingsPage(),
        ],
      ),
    );
  }
}
