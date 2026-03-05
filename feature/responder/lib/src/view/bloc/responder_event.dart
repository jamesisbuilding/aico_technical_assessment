import 'package:responder/src/domain/model/alert_entity.dart';
import 'package:responder/src/domain/model/responder_action.dart';

sealed class ResponderEvent {}

class streamAlertsEvent extends ResponderEvent {}

class HandleResponseAction extends ResponderEvent {
  final ResponderAction action;
  HandleResponseAction({required this.action});
}

class UpdateAlertFromPending extends ResponderEvent {}

class UpdateAlertEvent extends ResponderEvent {
  final Alert? alert;
  UpdateAlertEvent({required this.alert});
}
