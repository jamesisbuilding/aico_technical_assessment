import 'package:responder/src/data/data_sources/alert_data_service.dart';
import 'package:responder/src/data/models/alert_model.dart';
import 'package:responder/src/domain/model/alert_entity.dart';
import 'package:responder/src/domain/repository/responder_repository.dart';

class ResponderRepoImpl implements ResponderRepository {
  final AlertDataService _alertDataService;

  ResponderRepoImpl(this._alertDataService);

  @override
  Stream<Alert> streamAlerts() {
    return _alertDataService.streamAlerts().map((model) => model);
  }

  @override
  Future<void> updateAlert({required Alert alert}) async {
    final model = AlertModel.fromEntity(alert);
    await _alertDataService.updateAlert(alert: model);
  }
}
