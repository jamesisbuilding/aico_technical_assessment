import 'package:responder/src/domain/model/alert_entity.dart';

class ResponderState {
  final Alert? currentAlert;
  final List<Alert> pendingAlerts;

  const ResponderState({
    this.currentAlert,
    this.pendingAlerts = const [],
  });

  factory ResponderState.empty() => const ResponderState();

  ResponderState copyWith({
    Object? currentAlert = const _Unset(),
    Object? pendingAlerts = const _Unset(),
  }) {
    return ResponderState(
      currentAlert: currentAlert is _Unset
          ? this.currentAlert
          : currentAlert as Alert?,
      pendingAlerts: pendingAlerts is _Unset
          ? this.pendingAlerts
          : pendingAlerts as List<Alert>,
    );
  }
}

class _Unset {
  const _Unset();
}
