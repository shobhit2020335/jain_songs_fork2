import 'package:build_config/config.dart';

class DevelopmentBuildConfig extends BuildConfig {
  @override
  final Map<String, dynamic> configs = {
    'serverUrl': 'https://api.production.com',
  };
}
