import 'package:responder/src/data/data_sources/alert_data_service.dart';
import 'package:responder/src/data/models/alert_model.dart';
import 'package:responder/src/domain/model/alert_entity.dart';
import 'package:responder/src/domain/repository/responder_repository.dart';

class ResponderRepoImpl implements ResponderRepository {
  final AlertDataService _alertDataService;

  static ResponderRepoImpl? _instance;

  ResponderRepoImpl._internal(this._alertDataService);

  static void init(AlertDataService alertDataService) {
    _instance ??= ResponderRepoImpl._internal(alertDataService);
  }

  static ResponderRepoImpl get instance {
    final repo = _instance;
    if (repo == null) {
      throw StateError(
        'ResponderRepoImpl.instance called before initialization. '
        'Call ResponderRepoImpl.init() first.',
      );
    }
    return repo;
  }

  @override
  Stream<Alert> streamAlerts() {
    return _alertDataService.streamAlerts().map((model) => model as Alert);
  }

  @override
  Future<void> updateAlert({required Alert alert}) async {
    final model = AlertModel.fromEntity(alert);

    await _alertDataService.updateAlert(alert: model);
  }
}
