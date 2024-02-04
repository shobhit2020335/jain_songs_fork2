import 'package:get_it/get_it.dart';
import 'package:jain_songs/services/event_logging/analytics_service.dart';
import 'package:jain_songs/services/event_logging/google_analytics_service.dart';
import 'package:jain_songs/services/event_logging/mixpanel_analytics_service.dart';

GetIt locator = GetIt.instance;

Future<void> initializeLocator() async {
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => GoogleAnalyticsService());
  locator.registerLazySingleton(() => MixPanelAnalytics());
}
