import 'package:jain_songs/locator.dart';
import 'package:jain_songs/services/event_logging/base_analytics_service.dart';
import 'package:jain_songs/services/event_logging/google_analytics_service.dart';
import 'package:jain_songs/services/event_logging/mixpanel_analytics_service.dart';

class AnalyticsService extends BaseAnalyticsService {
  final GoogleAnalyticsService _googleAnalyticsService =
      locator<GoogleAnalyticsService>();
  final MixPanelAnalytics _mixPanelAnalytics = locator<MixPanelAnalytics>();

  @override
  Future<void> login() async {
    _googleAnalyticsService.login();
    _mixPanelAnalytics.login();
  }

  @override
  Future<void> logout() async {
    _googleAnalyticsService.logout();
    _mixPanelAnalytics.logout();
  }

  @override
  Future<void> track(
      {required String eventName,
      required Map<String, dynamic> properties}) async {
    _googleAnalyticsService.track(eventName: eventName, properties: properties);
    _mixPanelAnalytics.track(eventName: eventName, properties: properties);
  }
}
