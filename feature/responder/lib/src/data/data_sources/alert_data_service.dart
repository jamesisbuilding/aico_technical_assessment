import 'package:responder/src/data/models/alert_model.dart';

abstract class AlertDataService {
  Stream<AlertModel> streamAlerts();
  Future<void> updateAlert({required AlertModel alert});
}