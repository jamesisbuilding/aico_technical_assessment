import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:responder/src/data/data_sources/alert_data_service.dart';
import 'package:responder/src/data/models/alert_model.dart';
import 'package:responder/src/data/repositories/responder_repo_impl.dart';
import 'package:responder/src/domain/model/alert_entity.dart';
import 'package:responder/src/domain/model/responder_action.dart';

class _FakeAlertDataService implements AlertDataService {
  final controller = StreamController<AlertModel>();
  AlertModel? updatedAlert;

  @override
  Stream<AlertModel> streamAlerts() => controller.stream;

  @override
  Future<void> updateAlert({required AlertModel alert}) async {
    updatedAlert = alert;
  }
}

AlertModel _buildModel() => AlertModel(
  uid: 'A1',
  sentAt: DateTime(2026, 1, 1),
  alertType: AlertType.fire,
  address: '1 Test Street',
  senderName: 'Test User',
  status: AlertStatus.active,
  availableActions: const [
    ResponderAction.aOk,
    ResponderAction.callFireServices,
  ],
);

void main() {
  group('ResponderRepoImpl', () {
    late _FakeAlertDataService service;
    late ResponderRepoImpl repo;

    setUpAll(() {
      service = _FakeAlertDataService();

      repo = ResponderRepoImpl(service);
    });

    tearDownAll(() async {
      await service.controller.close();
    });

    test(
      'streamAlerts exposes Alert entities from data service stream',
      () async {
        final model = _buildModel();
        Future<Alert> firstAlert = repo.streamAlerts().first;

        service.controller.add(model);

        final alert = await firstAlert;
        expect(alert, isA<Alert>());
        expect(alert.uid, model.uid);
        expect(alert.alertType, AlertType.fire);
      },
    );

    test(
      'updateAlert converts entity to model and forwards to data service',
      () async {
        final alert = _buildModel();

        await repo.updateAlert(alert: alert);

        expect(service.updatedAlert, isNotNull);
        expect(service.updatedAlert!.uid, alert.uid);
        expect(service.updatedAlert!.status, alert.status);
        expect(service.updatedAlert!.availableActions, alert.availableActions);
      },
    );
  });
}
