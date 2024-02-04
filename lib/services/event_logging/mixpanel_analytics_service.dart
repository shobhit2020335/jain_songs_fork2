import 'dart:developer';

import 'package:jain_songs/services/event_logging/base_analytics_service.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixPanelAnalytics extends BaseAnalyticsService {
  static const PROD_TOKEN = "f8e0a5b99cb167ef95f9e4ebfd2fc796";

  Mixpanel? _mixpanel;

  @override
  Future<void> login() async {
    _mixpanel = await Mixpanel.init(
      PROD_TOKEN,
      trackAutomaticEvents: false,
      optOutTrackingDefault: false,
    );
  }

  @override
  Future<void> logout() async {
    _mixpanel!.reset();
  }

  @override
  Future<void> track(
      {required String eventName,
      required Map<String, dynamic> properties}) async {
    print(eventName);
    try {
      if (_mixpanel == null) {
        login().then(
            (value) => track(eventName: eventName, properties: properties));
      } else {
        if (properties != null && properties.isNotEmpty) {
          _mixpanel!.track(eventName, properties: properties);
        } else {
          _mixpanel!.track(eventName);
        }
      }
    } catch (e) {
      log(e.toString(), name: 'Mixpanel Error');
    }
  }
}
