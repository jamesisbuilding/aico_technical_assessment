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
      expect(first.uid, 'ABCDE1');
      expect(first.senderName, 'John Corn');
      expect(first.address, '24 Lema Lane, BS1 8MN');
      expect(first.alertType, AlertType.pendantActivation);
      expect(first.status, AlertStatus.active);
      expect(first.availableActions.first, ResponderAction.aOk);
      expect(
        first.availableActions,
        isNot(contains(ResponderAction.callFireServices)),
      );
      expect(
        first.availableActions,
        isNot(contains(ResponderAction.callPlumber)),
      );
    });

    test('generated non-first alerts are fire/water and include required actions', () async {
      final service = LocalAlertDataService();
      final alerts = await service.streamAlerts().toList();

      final generated = alerts.skip(1);
      for (final alert in generated) {
        expect(
          alert.alertType == AlertType.fire || alert.alertType == AlertType.waterLeak,
          isTrue,
        );
        expect(alert.availableActions.first, ResponderAction.aOk);

        if (alert.alertType == AlertType.fire) {
          expect(alert.availableActions, contains(ResponderAction.callFireServices));
        }
        if (alert.alertType == AlertType.waterLeak) {
          expect(alert.availableActions, contains(ResponderAction.callPlumber));
        }

        expect(RegExp(r'^[A-Z0-9]{7}$').hasMatch(alert.uid), isTrue);
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
