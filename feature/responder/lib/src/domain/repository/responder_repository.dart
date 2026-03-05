import 'package:responder/src/domain/model/alert_entity.dart';

abstract class ResponderRepository {
  Stream<Alert> streamAlerts();
  Future<void> updateAlert({required Alert alert});
}
