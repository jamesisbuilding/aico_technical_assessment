import 'package:get_it/get_it.dart';
import 'package:responder/responder.dart';

final GetIt getIt = GetIt.instance;

void registerServices() {
  registerResponderAlertDependencies(getIt);
}
