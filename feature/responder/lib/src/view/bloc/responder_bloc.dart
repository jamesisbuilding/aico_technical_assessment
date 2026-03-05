import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responder/src/domain/model/alert_entity.dart';
import 'package:responder/src/domain/model/responder_action.dart';
import 'package:responder/src/domain/repository/responder_repository.dart';
import 'package:responder/src/view/bloc/responder_event.dart';
import 'package:responder/src/view/bloc/responder_state.dart';

class ResponderBloc extends Bloc<ResponderEvent, ResponderState> {
  final ResponderRepository _repo;
  ResponderBloc({required ResponderRepository repo})
    : _repo = repo,
      super(ResponderState.empty()) {
    on<StreamAlertsEvent>(_streamAlertsEvent);
    on<HandleResponseAction>(_handleResponseAction);
    on<UpdateAlertEvent>(_updateAlertEvent);
    on<UpdateAlertFromPending>(_updateAlertFromPending);
  }

  Future<void> _streamAlertsEvent(
    StreamAlertsEvent event,
    Emitter<ResponderState> emit,
  ) async {
    await emit.forEach<Alert>(
      _repo.streamAlerts(),
      onData: (alert) {
        if (state.currentAlert != null) {
          final pendingAlerts = List<Alert>.from(state.pendingAlerts)..add(alert);
          return state.copyWith(pendingAlerts: pendingAlerts);
        }
        return state.copyWith(currentAlert: alert, streamError: null);
      },
      onError: (error, stackTrace) {
        return state.copyWith(streamError: error.toString());
      },
    );
  }

  void _handleResponseAction(
    HandleResponseAction event,
    Emitter<ResponderState> emit,
  ) {
    switch (event.action) {
      case ResponderAction.aOk:
        final currentAlert = state.currentAlert;
        if (currentAlert == null) return;
        add(
          UpdateAlertEvent(
            alert: currentAlert.copyWith(status: AlertStatus.resolved),
          ),
        );
      case ResponderAction.goProperty:
      case ResponderAction.noVisit:
      case ResponderAction.callDr:
      case ResponderAction.callPlumber:
      case ResponderAction.callFireServices:
        return;
    }
  }

  Future<void> _updateAlertEvent(
    UpdateAlertEvent event,
    Emitter<ResponderState> emit,
  ) async {
    if (event.alert != null) {
      await _repo.updateAlert(alert: event.alert!);
    } else {
      add(UpdateAlertFromPending());
    }
    emit(state.copyWith(currentAlert: event.alert));
  }

  Future<void> _updateAlertFromPending(
    UpdateAlertFromPending event,
    Emitter<ResponderState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    if (state.pendingAlerts.isNotEmpty) {
      final pendingAlerts = List<Alert>.from(state.pendingAlerts);
      final nextAlert = pendingAlerts.removeAt(0);
      emit(state.copyWith(currentAlert: nextAlert, pendingAlerts: pendingAlerts));
    }
  }
}
