import 'package:responder/src/data/data_sources/alert_data_service.dart';
import 'package:responder/src/data/models/alert_model.dart';
import 'package:responder/src/domain/model/alert_entity.dart';
import 'package:responder/src/domain/model/responder_action.dart';

import 'dart:math';

class LocalAlertDataService implements AlertDataService {
  final _random = Random();

  static const _names = [
    'Alice Brown',
    'Chris Martin',
    'Sam Taylor',
    'Jamie Wheat',
    'Morgan Yu',
    'Jess Fox',
  ];

  static const _addresses = [
    '13 Baker Street, NW1 6XE',
    '42 North Ave, M14 5QS',
    '200 Lake Drive, SW1A 2AA',
    '98 Summerhill Rd, L5 3UF',
    '6 Oak Crescent, CB4 9HG',
    '18 and 3/4 Acacia Ave, LS6 9WH'
  ];

  static const _alertTypes = [
    AlertType.pendantActivation,
    AlertType.fire,
    AlertType.waterLeak,
  ];

  static const _allActions = [
    ResponderAction.aOk,
    ResponderAction.goProperty,
    ResponderAction.callDr,
    ResponderAction.noVisit,
  ];

  // Additional specific actions for fire and water leak
  static const _fireActions = [
    ResponderAction.callFireServices,
  ];

  static const _leakActions = [
    ResponderAction.callPlumber,
  ];

  String _randomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    try {
      return String.fromCharCodes(
        Iterable.generate(7, (_) => chars.codeUnitAt(_random.nextInt(chars.length))),
      );
    } catch (e) {
      // Fallback if something goes wrong
      return 'ERR_ID0';
    }
  }

  List<ResponderAction> _randomActionsForType(AlertType type) {
    try {
      // Always have aOk first
      final actions = <ResponderAction>[ResponderAction.aOk];

      // By default, always possible actions (minus aOk)
      final rest = List<ResponderAction>.from(_allActions);
      rest.remove(ResponderAction.aOk);

      // Add type-specific actions
      if (type == AlertType.fire) {
        rest.addAll(_fireActions);
      } else if (type == AlertType.waterLeak) {
        rest.addAll(_leakActions);
      }

      rest.shuffle(_random);

      // Pick at least 1 additional (total at least 2 overall)
      int num = 1 + _random.nextInt(rest.length > 1 ? rest.length - 1 : 1);
      actions.addAll(rest.take(num));

      // If not already included, ensure extra action for fire/leak
      if (type == AlertType.fire &&
          !actions.contains(ResponderAction.callFireServices)) {
        actions.add(ResponderAction.callFireServices);
      } else if (type == AlertType.waterLeak &&
          !actions.contains(ResponderAction.callPlumber)) {
        actions.add(ResponderAction.callPlumber);
      }
      return actions;
    } catch (e) {
      // Return default safe fallback
      return [ResponderAction.aOk];
    }
  }

  @override
  Stream<AlertModel> streamAlerts() async* {
    for (var i = 0; i < 3; i++) {
      try {
        await Future.delayed(const Duration(seconds: 2));
        if (i == 0) {
          // Pendant activation (no fire/plumber actions), ensure aOk first
          List<ResponderAction> actions = List<ResponderAction>.from(_allActions);
          actions.remove(ResponderAction.aOk);
          actions.insert(0, ResponderAction.aOk);
          yield AlertModel(
            uid: 'ABCDE1',
            senderName: 'John Corn',
            sentAt: DateTime.now(),
            alertType: AlertType.pendantActivation,
            address: '24 Lema Lane, BS1 8MN',
            status: AlertStatus.active,
            availableActions: actions,
          );
        } else {
          final type = _alertTypes[1 + _random.nextInt(_alertTypes.length - 1)]; // fire or waterLeak
          yield AlertModel(
            uid: _randomId(),
            senderName: _names[_random.nextInt(_names.length)],
            sentAt: DateTime.now(),
            alertType: type,
            address: _addresses[_random.nextInt(_addresses.length)],
            status: AlertStatus.active,
            availableActions: _randomActionsForType(type),
          );
        }
      } catch (e) {
        // Handle error for each attempt by yielding a special error alert or skip
        yield AlertModel(
          uid: 'ERROR',
          senderName: 'Error',
          sentAt: DateTime.now(),
          alertType: AlertType.pendantActivation,
          address: 'Unknown address',
          status: AlertStatus.idle,
          availableActions: [ResponderAction.aOk],
        );
      }
    }
  }

  @override
  Future<void> updateAlert({required AlertModel alert}) async {
    // no-op for now (stubbed local datasource)
    try {
      // Could simulate update, but intentionally stubbed
    } catch (e) {
      // In real impl, log or handle error
    }
  }
}
