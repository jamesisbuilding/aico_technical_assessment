import 'package:responder/responder.dart';

import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void registerServices() {
  regiserResponderAlertDependencies(getIt);
}
