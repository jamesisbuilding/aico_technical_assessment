import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:responder/src/domain/model/alert_entity.dart';

extension AlertStatusUi on AlertStatus {
  Color get color {
    switch (this) {
      case AlertStatus.idle:
        return Colors.white;
      case AlertStatus.active:
        return AppTheme.alert;
      case AlertStatus.resolved:
        return AppTheme.success;
    }
  }

  String? get confirmationLabel {
    switch (this) {
      case AlertStatus.resolved:
        return 'Resolved';
      case AlertStatus.idle:
      case AlertStatus.active:
        return null;
    }
  }
}
