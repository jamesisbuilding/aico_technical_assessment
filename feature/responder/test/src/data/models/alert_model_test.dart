import 'package:flutter_test/flutter_test.dart';
import 'package:responder/src/data/models/alert_model.dart';
import 'package:responder/src/domain/model/alert_entity.dart';
import 'package:responder/src/domain/model/responder_action.dart';

void main() {
  group('AlertModel', () {
    test('fromJson maps valid payload including available actions', () {
      final model = AlertModel.fromJson({
        'uid': 'AL12345',
        'sentAt': '2026-01-01T12:00:00.000Z',
        'alertType': 'fire',
        'address': '1 Test Street',
        'senderName': 'Tester',
        'status': 'active',
        'availableActions': ['aOk', 'callFireServices'],
      });

      expect(model.uid, 'AL12345');
      expect(model.alertType, AlertType.fire);
      expect(model.status, AlertStatus.active);
      expect(model.availableActions, [ResponderAction.aOk, ResponderAction.callFireServices]);
    });

    test('fromJson falls back for unknown values and ignores invalid actions', () {
      final model = AlertModel.fromJson({
        'uid': 'AL99999',
        'alertType': 'invalid-type',
        'status': 'invalid-status',
        'availableActions': ['aOk', 'notRealAction'],
      });

      expect(model.uid, 'AL99999');
      expect(model.sentAt, DateTime.fromMillisecondsSinceEpoch(0));
      expect(model.alertType, AlertType.unknown);
      expect(model.status, AlertStatus.idle);
      expect(model.availableActions, [ResponderAction.aOk]);
    });

    test('toJson serializes expected fields', () {
      final model = AlertModel(
        uid: 'AL12345',
        sentAt: DateTime.utc(2026, 1, 1, 12),
        alertType: AlertType.waterLeak,
        address: '22 Example Road',
        senderName: 'Jane',
        status: AlertStatus.resolved,
        availableActions: const [ResponderAction.aOk, ResponderAction.callPlumber],
      );

      final json = model.toJson();

      expect(json['uid'], 'AL12345');
      expect(json['alertType'], 'waterLeak');
      expect(json['address'], '22 Example Road');
      expect(json['senderName'], 'Jane');
      expect(json['status'], 'resolved');
      expect(json.containsKey('availableActions'), isFalse);
    });

    test('fromEntity preserves all fields', () {
      final entity = Alert(
        uid: 'AL77777',
        sentAt: DateTime.utc(2026, 1, 1, 9),
        alertType: AlertType.pendantActivation,
        address: '9 Main Street',
        senderName: 'John',
        status: AlertStatus.active,
        availableActions: const [ResponderAction.aOk, ResponderAction.callDr],
      );

      final model = AlertModel.fromEntity(entity);

      expect(model.uid, entity.uid);
      expect(model.sentAt, entity.sentAt);
      expect(model.alertType, entity.alertType);
      expect(model.address, entity.address);
      expect(model.senderName, entity.senderName);
      expect(model.status, entity.status);
      expect(model.availableActions, entity.availableActions);
    });
  });
}
