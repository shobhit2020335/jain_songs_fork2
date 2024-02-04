abstract class BaseAnalyticsService {
  Future<void> login();

  Future<void> track(
      {required String eventName, required Map<String, dynamic> properties});

  Future<void> logout();
}
