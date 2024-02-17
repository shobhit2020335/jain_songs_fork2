import 'package:go_router/go_router.dart';

abstract class RouterModule {
  Map<String,RouteBase>? getRoutes();
}