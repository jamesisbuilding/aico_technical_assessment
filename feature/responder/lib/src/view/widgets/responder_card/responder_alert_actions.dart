import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:responder/src/domain/model/responder_action.dart';

class ResponderAlertActions extends StatelessWidget {
  final List<ResponderAction> actions;
  final Function(ResponderAction) onActionTap;
  const ResponderAlertActions({
    super.key,
    required this.actions,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('actions'),
      children: actions
          .map(
            (rA) => PrimaryButton(
              label: rA.label,
              onTap: () => onActionTap(rA)
            ),
          )
          .toList(),
    );
  }
}
