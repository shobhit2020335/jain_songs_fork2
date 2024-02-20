import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CentralNavigator {
  static final CentralNavigator _instance = CentralNavigator._();
  CentralNavigator._();

  static CentralNavigator get instance => _instance;
  Listenable? refreshListenable;
  String? initialLocation;
  GlobalKey<NavigatorState>? navigatorKey;
  RouteRedirect? _commonRedirect;

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

  void addRoutes(List<Map<String, RouteBase>> routes) {
    for (var route in routes) {
      print(route.keys.first);
      if (_routes.containsKey(route.keys.first)) {
        throw ArgumentError(
            'Route already exists for feature: ${route.keys.first}');
      }
      _routes[route.keys.first] = route.values.first;
    }
  }

  void setCommonRedirect(RouteRedirect redirect) {
    if (_commonRedirect != null) {
      throw ArgumentError('A common redirect has already been set.');
    }
    _commonRedirect = redirect;
  }

  List<RouteBase> get allRoutes => _routes.values.toList();

  GoRouter buildRouter() {
    return GoRouter(
      routes: allRoutes,
      debugLogDiagnostics: true,
      initialLocation: initialLocation,
      navigatorKey: navigatorKey,
      refreshListenable: refreshListenable,
      redirect: (context, state) {
        final commonRedirectPath =
            _commonRedirect?.redirect(state.matchedLocation);
        if (commonRedirectPath != null) {
          return commonRedirectPath;
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
