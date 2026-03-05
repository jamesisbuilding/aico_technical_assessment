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
    on<streamAlertsEvent>(_streamAlertsEvent);
    on<HandleResponseAction>(_handleResponseAction);
    on<UpdateAlertEvent>(_updateAlertEvent);
    on<UpdateAlertFromPending>(_updateAlertFromPending);
  }

  _streamAlertsEvent(event, emit) async {
    await emit.forEach<Alert>(
      _repo.streamAlerts(),
      onData: (alert) {
        if (state.currentAlert != null) {
          List<Alert> pendingAlerts = List.from(state.pendingAlerts);
          pendingAlerts.add(alert);
          return state.copyWith(pendingAlerts: pendingAlerts);
        } else {
          return state.copyWith(currentAlert: alert);
        }
      },
    );
  }

  _handleResponseAction(event, emit) {
    switch (event.action) {
      case ResponderAction.aOk:
        add(
          UpdateAlertEvent(
            alert: state.currentAlert!.copyWith(status: AlertStatus.resolved),
          ),
        );
      case ResponderAction.goProperty:
      case ResponderAction.noVisit:
      case ResponderAction.callDr:
        return;
    }
  }

  _updateAlertEvent(event, emit) async {
    if (event.alert != null) {
      await _repo.updateAlert(alert: event.alert);
    } else {
      add(UpdateAlertFromPending());
    }
    emit(state.copyWith(currentAlert: event.alert));
  }

  _updateAlertFromPending(event, emit) async {
    await Future.delayed(const Duration(seconds: 1));
    if (state.pendingAlerts.isNotEmpty) {
      List<Alert> pendingAlerts = List.from(state.pendingAlerts);
      Alert nextAlert = pendingAlerts[0];
      pendingAlerts.removeAt(0);
      emit(
        state.copyWith(currentAlert: nextAlert, pendingAlerts: pendingAlerts),
      );
    }
  }
}
