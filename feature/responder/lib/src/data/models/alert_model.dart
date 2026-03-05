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
    List<ResponderAction> availableActions = [];

    if (json['availableActions'] != null) {
      for (var jsonAction in json['availableActions']) {
        try {
          ResponderAction? action = ResponderAction.values.firstWhere(
            (a) => a.name == jsonAction,
          );
          availableActions.add(action);
        } catch (e) {
          debugPrint('Failed to assign action');
        }
      }
    }
    return AlertModel(
      uid: json['uid'] ?? '',
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'])
          : DateTime.fromMillisecondsSinceEpoch(0),
      alertType: json['alertType'] != null
          ? AlertType.values.firstWhere(
              (e) => e.name == json['alertType'],
              orElse: () => AlertType.unknown,
            )
          : AlertType.unknown,
      address: json['address'] ?? '',
      senderName: json['senderName'] ?? '',
      status: json['status'] != null
          ? AlertStatus.values.firstWhere(
              (e) => e.name == json['status'],
              orElse: () => AlertStatus.idle,
            )
          : AlertStatus.idle,
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
