import 'dart:async';

import 'package:feature_resolver/resolver.dart';
import 'package:build_config/config.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jain_songs/app_injection_component.dart';
import 'package:jain_songs/jain_app_resolver.dart';
import 'package:jain_songs/main.dart';

abstract class AppStart {
  final BuildConfig buildConfig;

  final resolvers = <FeatureResolver>[
    JainAppResolver(),
  ];

  AppStart(this.buildConfig);

  Future<void> startApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    final routerModules = <RouterModule>[];

    final delegates = <LocalizationsDelegate>[
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
    // final injections = <InjectionModule>[];

    for (final resolver in resolvers) {
      if (resolver.routerModule != null) {
        routerModules.add(resolver.routerModule!);
      }

      // if (resolver.localeDelegate != null) {
      //   delegates.add(resolver.localeDelegate!);
      // }

      // if (resolver.injectionModule != null) {
      //   injections.add(resolver.injectionModule!);
      // }
    }

    await AppInjectionComponent.instance.registerModules(
      config: buildConfig,
    );

    // AppInjector.I.getAppLocale().updateAppLocale(appSupportedLanguages.first);

    await runZonedGuarded<Future<void>>(
      () async {
        runApp(
          MainTheme(
            routes: routerModules,
            // localeDelegates: delegates,
          ),
        );
      },
      (error, stackTrace) =>
          FirebaseCrashlytics.instance.recordError(error, stackTrace),
    );
  }
}
