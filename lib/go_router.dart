import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jain_songs/custom_widgets/build_playlist_list.dart';
import 'package:jain_songs/form_page.dart';
import 'package:jain_songs/home_page.dart';
import 'package:jain_songs/information_page.dart';
import 'package:jain_songs/playlist_page.dart';
import 'package:jain_songs/settings_page.dart';
import 'package:jain_songs/all_songs_page.dart';
import 'package:jain_songs/song_details_router_object.dart';
import 'package:jain_songs/song_page.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'package:jain_songs/utilities/settings_details.dart';

final GlobalKey<NavigatorState> tab1 = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> tab2 = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> tab3 = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> tab4 = GlobalKey<NavigatorState>();

final myRoutes = <Map<String, RouteBase>>[
  {
    "statefullRoute": StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          var includeBottomBar = [
            '/v2',
            '/v2/recommend',
            '/v2/allplaylist',
            '/v2/info'
          ].contains(state.uri.path);
          return includeBottomBar
              ? HomePage(navigationShell: navigationShell)
              : navigationShell;
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(navigatorKey: tab1, routes: <RouteBase>[
            GoRoute(
                path: '/v2',
                builder: (BuildContext context, GoRouterState state) {
                  return const SongsView();
                },
                routes: [
                  GoRoute(
                    path: 'songDetails',
                    builder: (BuildContext context, GoRouterState state) {
                      final myObject = state.extra! as SongDetailsObject;
                      return SongPage(
                        currentSong: myObject.currentSong,
                        suggester: myObject.suggester,
                        suggestionStreak: myObject.suggestionStreak,
                        postitionInList: myObject.postitionInList,
                      );
                    },
                  ),
                ]),
          ]),
          StatefulShellBranch(navigatorKey: tab2, routes: <RouteBase>[
            GoRoute(
              path: '/v2/recommend',
              builder: (BuildContext context, GoRouterState state) {
                return const FormPage();
              },
            ),
          ]),
          StatefulShellBranch(navigatorKey: tab3, routes: <RouteBase>[
            GoRoute(
                path: '/v2/allplaylist',
                builder: (BuildContext context, GoRouterState state) {
                  return const BuildPlaylistList();
                },
                routes: [
                  GoRoute(
                      path: ':playlist',
                      builder: (BuildContext context, GoRouterState state) {
                        final playlistDetails = state.extra as PlaylistDetails;
                        return PlaylistPage(currentPlaylist: playlistDetails);
                      },
                      routes: [
                        GoRoute(
                          path: 'songDetails',
                          builder: (BuildContext context, GoRouterState state) {
                            final myObject = state.extra! as SongDetailsObject;
                            return SongPage(
                              currentSong: myObject.currentSong,
                              suggester: myObject.suggester,
                              suggestionStreak: myObject.suggestionStreak,
                              postitionInList: myObject.postitionInList,
                            );
                          },
                        ),
                      ]),
                ]),
          ]),
          StatefulShellBranch(navigatorKey: tab4, routes: <RouteBase>[
            GoRoute(
                path: '/v2/info',
                builder: (BuildContext context, GoRouterState state) {
                  return const SettingsPage();
                },
                routes: [
                  GoRoute(
                    path: 'about',
                    builder: (BuildContext context, GoRouterState state) {
                      final settingsDetails = state.extra as SettingsDetails;
                      return InformationPage(
                        settingsDetails,
                      );
                    },
                  ),
                ]),
          ])
        ])
  }
];
