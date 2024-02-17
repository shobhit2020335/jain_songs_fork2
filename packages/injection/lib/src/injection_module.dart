import 'dart:async';

abstract class InjectableModule {
  FutureOr<void>? registerDependencies();
}
