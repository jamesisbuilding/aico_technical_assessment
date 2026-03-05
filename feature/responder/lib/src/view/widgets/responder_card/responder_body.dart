import 'package:flutter/material.dart';
import 'package:responder/src/domain/model/alert_entity.dart';
import 'package:responder/src/domain/model/responder_action.dart';
import 'package:responder/src/view/widgets/responder_card/responder_alert_actions.dart';
import 'package:responder/src/view/widgets/responder_card/responder_confirmation_body.dart';

class ResponderBody extends StatelessWidget {
  final bool visible;
  final Alert alert;
  final Function(ResponderAction) onActionTap;
  final VoidCallback onConfirmationComplete;
  const ResponderBody({
    super.key,
    required this.visible,
    required this.alert,
    required this.onActionTap,
    required this.onConfirmationComplete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),

      opacity: visible ? 1 : 0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: alert.status == AlertStatus.active
            ? ResponderAlertActions(
                actions: alert.availableActions,
                onActionTap: (rA) => onActionTap(rA),
              )
            : ConfirmationBody(
                key: ValueKey('confirmation'),
                onConfirmationComplete: () => onConfirmationComplete(),
              ),
      ),
    );
  }
}
