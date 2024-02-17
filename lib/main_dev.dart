import 'package:jain_songs/app_start.dart';
import 'package:jain_songs/dev_build_config.dart';

class DevelopmentApp extends AppStart {
  DevelopmentApp() : super(DevelopmentBuildConfig());

  Future<void> main() => DevelopmentApp().startApp();
}
