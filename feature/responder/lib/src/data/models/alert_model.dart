import 'package:flutter/material.dart';
import 'package:responder/src/domain/model/alert_entity.dart';
import 'package:responder/src/domain/model/responder_action.dart';

class AlertModel extends Alert {
  const AlertModel({
    required super.uid,
    required super.sentAt,
    required super.alertType,
    required super.address,
    required super.senderName,
    required super.status,
    required super.availableActions,
  });

  factory AlertModel.empty() => AlertModel(
    uid: '',
    sentAt: DateTime.fromMillisecondsSinceEpoch(0),
    alertType: AlertType.unknown,
    address: '',
    senderName: '',
    status: AlertStatus.idle,
    availableActions: const [],
  );

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    final List<ResponderAction> availableActions = [];

    final dynamic rawActions = json['availableActions'];
    if (rawActions is Iterable) {
      for (final jsonAction in rawActions) {
        final matchingActions = ResponderAction.values.where((a) => a.name == jsonAction);
        if (matchingActions.isNotEmpty) {
          availableActions.add(matchingActions.first);
        } else {
          debugPrint('Failed to assign action');
        }
      }
    }

    final sentAt = DateTime.tryParse('${json['sentAt'] ?? ''}') ??
        DateTime.fromMillisecondsSinceEpoch(0);

    return AlertModel(
      uid: json['uid']?.toString() ?? '',
      sentAt: sentAt,
      alertType: AlertType.values.firstWhere(
        (e) => e.name == json['alertType'],
        orElse: () => AlertType.unknown,
      ),
      address: json['address']?.toString() ?? '',
      senderName: json['senderName']?.toString() ?? '',
      status: AlertStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AlertStatus.idle,
      ),
      availableActions: availableActions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'sentAt': sentAt.toIso8601String(),
      'alertType': alertType.name,
      'address': address,
      'senderName': senderName,
      'status': status.name,
    };
  }

  factory AlertModel.fromEntity(Alert alert) {
    return AlertModel(
      uid: alert.uid,
      sentAt: alert.sentAt,
      alertType: alert.alertType,
      address: alert.address,
      senderName: alert.senderName,
      status: alert.status,
      availableActions: alert.availableActions,
    );
  }
}
