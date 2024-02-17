import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CentralNavigator {
  static final CentralNavigator _instance = CentralNavigator._();
  CentralNavigator._();

  static CentralNavigator get instance => _instance;
  Listenable? refreshListenable;
  String? initialLocation;
  GlobalKey<NavigatorState>? navigatorKey;

  final Map<String, RouteBase> _routes = {};

  void addRoute(String featureName, RouteBase route) {
    if (_routes.containsKey(featureName)) {
      throw ArgumentError('Route already exists for feature: $featureName');
    }
    _routes[featureName] = route;
  }

  void removeRoute(String featureName) {
    if (!_routes.containsKey(featureName)) {
      throw ArgumentError('No route found for feature: $featureName to remove');
    }
    _routes.remove(featureName);
  }

  List<RouteBase> get allRoutes => _routes.values.toList();

  GoRouter buildRouter() {
    final redirects = _routes.values
        .whereType<RouterAcceptor<RouteBase>>()
        .map((e) => e.redirect)
        .whereType<RouteRedirect>();
    return GoRouter(
      routes: allRoutes,
      initialLocation: initialLocation,
      navigatorKey: navigatorKey,
      refreshListenable: refreshListenable,
      redirect: (context, state) {
        for (final redirect in redirects) {
          final redirectPath = redirect.redirect(state.matchedLocation);
          if (redirectPath != null) {
            return redirectPath;
          }
        }
        return null; // No redirection by default
      },
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Page not found: ${state.error}')),
      ),
    );
  }
}

class RouterAcceptor<T extends RouteBase> {
  RouterAcceptor({
    required this.featureName,
    required this.route,
    this.redirect,
  });

  final String featureName;
  final T route;
  final RouteRedirect? redirect;
}

abstract class RouteRedirect {
  String? redirect(String currentLocation);
}
