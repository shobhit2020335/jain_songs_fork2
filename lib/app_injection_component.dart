import 'package:build_config/config.dart';

class AppInjectionComponent {
  AppInjectionComponent._();

  static AppInjectionComponent instance = AppInjectionComponent._();
  Future<void> registerModules({
    required BuildConfig config,
  }) async {
    ///Register dependencies here
  }
}
