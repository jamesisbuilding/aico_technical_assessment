import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:responder/src/domain/model/alert_entity.dart';
import 'package:responder/src/domain/model/responder_action.dart';
import 'package:responder/src/domain/repository/responder_repository.dart';
import 'package:responder/src/view/bloc/responder_bloc.dart';
import 'package:responder/src/view/bloc/responder_event.dart';

class _FakeResponderRepository implements ResponderRepository {
  _FakeResponderRepository(this._alertsStream);

  final Stream<Alert> _alertsStream;
  final List<Alert> updatedAlerts = [];

  @override
  Stream<Alert> streamAlerts() => _alertsStream;

  @override
  Future<void> updateAlert({required Alert alert}) async {
    updatedAlerts.add(alert);
  }
}

Alert _buildAlert(String id, {AlertType type = AlertType.pendantActivation}) {
  return Alert(
    uid: id,
    sentAt: DateTime(2026, 1, 1),
    alertType: type,
    status: AlertStatus.active,
    address: '1 Test Street',
    senderName: 'Test User',
    availableActions: const [ResponderAction.aOk, ResponderAction.callDr],
  );
}

void main() {
  group('ResponderBloc', () {
    test('sets current alert first and queues subsequent alerts as pending', () async {
      final controller = StreamController<Alert>();
      final repo = _FakeResponderRepository(controller.stream);
      final bloc = ResponderBloc(repo: repo);

      bloc.add(StreamAlertsEvent());
      final first = _buildAlert('A1');
      final second = _buildAlert('A2', type: AlertType.fire);
      controller
        ..add(first)
        ..add(second);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state.currentAlert, first);
      expect(bloc.state.pendingAlerts, [second]);

      await controller.close();
      await bloc.close();
    });


    test('captures stream errors in streamError state field', () async {
      final repo = _FakeResponderRepository(Stream<Alert>.error(Exception('boom')));
      final bloc = ResponderBloc(repo: repo);

      bloc.add(StreamAlertsEvent());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state.streamError, contains('boom'));

      await bloc.close();
    });
    test('UpdateAlertEvent with non-null alert updates repository and state', () async {
      final repo = _FakeResponderRepository(const Stream<Alert>.empty());
      final bloc = ResponderBloc(repo: repo);
      final alert = _buildAlert('A1');

      bloc.add(UpdateAlertEvent(alert: alert));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(repo.updatedAlerts, [alert]);
      expect(bloc.state.currentAlert, alert);

      await bloc.close();
    });

    test('aOk action resolves current alert and calls repository update', () async {
      final repo = _FakeResponderRepository(const Stream<Alert>.empty());
      final bloc = ResponderBloc(repo: repo);
      final alert = _buildAlert('A1');

      bloc.add(UpdateAlertEvent(alert: alert));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      bloc.add(HandleResponseAction(action: ResponderAction.aOk));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(repo.updatedAlerts, hasLength(2));
      expect(repo.updatedAlerts.last.status, AlertStatus.resolved);
      expect(bloc.state.currentAlert?.status, AlertStatus.resolved);

      await bloc.close();
    });

    test('non aOk response actions do not update repository', () async {
      final repo = _FakeResponderRepository(const Stream<Alert>.empty());
      final bloc = ResponderBloc(repo: repo);
      final alert = _buildAlert('A1');

      bloc.add(UpdateAlertEvent(alert: alert));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      bloc.add(HandleResponseAction(action: ResponderAction.goProperty));
      bloc.add(HandleResponseAction(action: ResponderAction.callDr));
      bloc.add(HandleResponseAction(action: ResponderAction.noVisit));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(repo.updatedAlerts, hasLength(1));
      expect(bloc.state.currentAlert, alert);

      await bloc.close();
    });

    test('UpdateAlertEvent(null) with empty pending leaves state unchanged', () async {
      final repo = _FakeResponderRepository(const Stream<Alert>.empty());
      final bloc = ResponderBloc(repo: repo);

      bloc.add(UpdateAlertEvent(alert: null));
      await Future<void>.delayed(const Duration(milliseconds: 1200));

      expect(bloc.state.currentAlert, isNull);
      expect(bloc.state.pendingAlerts, isEmpty);
      expect(repo.updatedAlerts, isEmpty);

      await bloc.close();
    });

    test('UpdateAlertEvent(null) pulls next alert from pending queue', () async {
      final controller = StreamController<Alert>();
      final repo = _FakeResponderRepository(controller.stream);
      final bloc = ResponderBloc(repo: repo);
      final first = _buildAlert('A1');
      final second = _buildAlert('A2');

      bloc.add(StreamAlertsEvent());
      controller
        ..add(first)
        ..add(second);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      bloc.add(UpdateAlertEvent(alert: null));
      await Future<void>.delayed(const Duration(milliseconds: 1200));

      expect(bloc.state.currentAlert, second);
      expect(bloc.state.pendingAlerts, isEmpty);

      await controller.close();
      await bloc.close();
    });
  });
}
