import 'package:get_it/get_it.dart';
import 'package:responder/src/data/data_sources/alert_data_service.dart';
import 'package:responder/src/data/data_sources/local_alert_data_service.dart';
import 'package:responder/src/data/repositories/responder_repo_impl.dart';
import 'package:responder/src/domain/repository/responder_repository.dart';
import 'package:responder/src/view/bloc/responder_bloc.dart';

void registerResponderAlertDependencies(GetIt getIt) {
  getIt.registerLazySingleton<AlertDataService>(() => LocalAlertDataService());
  getIt.registerLazySingleton<ResponderRepository>(
    () => ResponderRepoImpl(getIt<AlertDataService>()),
  );
  getIt.registerFactory<ResponderBloc>(
    () => ResponderBloc(repo: getIt<ResponderRepository>()),
  );
}
