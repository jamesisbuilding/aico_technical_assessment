import 'package:responder/src/domain/model/alert_entity.dart';

class ResponderState {
  final Alert? currentAlert;
  final List<Alert> pendingAlerts;
  final String? streamError;

  const ResponderState({
    this.currentAlert,
    this.pendingAlerts = const [],
    this.streamError,
  });

  factory ResponderState.empty() => const ResponderState();

  ResponderState copyWith({
    Object? currentAlert = const _Unset(),
    Object? pendingAlerts = const _Unset(),
    Object? streamError = const _Unset(),
  }) {
    return ResponderState(
      currentAlert: currentAlert is _Unset ? this.currentAlert : currentAlert as Alert?,
      pendingAlerts: pendingAlerts is _Unset
          ? this.pendingAlerts
          : pendingAlerts as List<Alert>,
      streamError: streamError is _Unset ? this.streamError : streamError as String?,
    );
  }
}

class _Unset {
  const _Unset();
}
