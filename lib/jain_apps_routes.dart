import 'package:feature_resolver/resolver.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jain_songs/custom_widgets/build_playlist_list.dart';
import 'package:jain_songs/form_page.dart';
import 'package:jain_songs/home_page.dart';
import 'package:jain_songs/settings_page.dart';

class JainAppRouter implements RouterModule {
  @override
  Map<String, RouteBase>? getRoutes() => <String, RouteBase>{
        "mainShell": ShellRoute(
          builder: (context, state, child) {
            var includeBottomBar = [
              '/songs',
              '/recommend',
              '/playlist',
              '/info'
            ].contains(state.uri.path);
            return includeBottomBar ? HomePage(child: child) : child;
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/songs',
              builder: (BuildContext context, GoRouterState state) {
                return const Placeholder();
                // const showProgress
                // ? const Center(
                //     child: CircularProgressIndicator(),
                //   )
                // : BuildList(
                //     scrollController: listScrollController,
                //     searchController: searchController,
                //   );
              },
            ),
            GoRoute(
              path: '/recommend',
              builder: (BuildContext context, GoRouterState state) {
                return const FormPage();
              },
            ),
            GoRoute(
              path: '/playlist',
              builder: (BuildContext context, GoRouterState state) {
                return const BuildPlaylistList();
              },
            ),
            GoRoute(
              path: '/info',
              builder: (BuildContext context, GoRouterState state) {
                return const SettingsPage();
              },
            ),
          ],
        ),
      };
}
