import 'package:injection_module/injection.dart';
import 'package:router_module/router.dart';

abstract class FeatureResolver {
  InjectableModule? get injectionModule;
  RouterModule? get routerModule;
}
