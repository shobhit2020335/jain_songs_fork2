import 'package:feature_resolver/resolver.dart';
import 'package:jain_songs/jain_apps_routes.dart';

class JainAppResolver implements FeatureResolver {
  @override
  InjectableModule? get injectionModule => throw UnimplementedError();

  @override
  RouterModule? get routerModule => JainAppRouter();
}
