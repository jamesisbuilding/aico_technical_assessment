import 'package:flutter_test/flutter_test.dart';
import 'package:responder/src/data/data_sources/local_alert_data_service.dart';
import 'package:responder/src/data/models/alert_model.dart';
import 'package:responder/src/domain/model/alert_entity.dart';
import 'package:responder/src/domain/model/responder_action.dart';

void main() {
  group('LocalAlertDataService', () {
    test('streamAlerts emits 3 alerts with expected first alert shape', () async {
      final service = LocalAlertDataService();

      final alerts = await service.streamAlerts().toList();

      expect(alerts, hasLength(3));
      final first = alerts.first;
      expect(first.alertType, AlertType.pendantActivation);
      expect(first.status, AlertStatus.active);
      expect(first.availableActions.first, ResponderAction.aOk);
      expect(first.availableActions, isNot(contains(ResponderAction.callFireServices)));
      expect(first.availableActions, isNot(contains(ResponderAction.callPlumber)));
    });

    test('non-pendant alerts include required type-specific actions', () async {
      final service = LocalAlertDataService();
      final alerts = await service.streamAlerts().toList();

      final generated = alerts.skip(1);
      for (final alert in generated) {
        if (alert.alertType == AlertType.fire) {
          expect(alert.availableActions, contains(ResponderAction.callFireServices));
        }
        if (alert.alertType == AlertType.waterLeak) {
          expect(alert.availableActions, contains(ResponderAction.callPlumber));
        }
      }
    });

    test('updateAlert completes without throwing', () async {
      final service = LocalAlertDataService();
      final alert = AlertModel(
        uid: 'A1',
        sentAt: DateTime(2026, 1, 1),
        alertType: AlertType.pendantActivation,
        address: '1 Test Street',
        senderName: 'Test User',
        status: AlertStatus.active,
        availableActions: const [ResponderAction.aOk],
      );

      await expectLater(service.updateAlert(alert: alert), completes);
    });
  });
}
