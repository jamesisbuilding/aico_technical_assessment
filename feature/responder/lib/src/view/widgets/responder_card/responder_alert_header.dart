import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:responder/src/domain/model/alert_entity.dart';

class ResponderAlertHeader extends StatelessWidget {
  final Alert? alert;
  const ResponderAlertHeader({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (alert == null) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        // const SizedBox(height: 2),
        AnimatedContainer(
          padding: const EdgeInsets.only(bottom: 8),
          duration: const Duration(milliseconds: 250),
          height: alert!.status == AlertStatus.resolved ? 45 : 0,
          width: double.infinity,
          curve: animationCurve,
          decoration: alert!.status == AlertStatus.resolved
              ? const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.borderGrey,
                      width: 2,
                    ),
                  ),
                )
              : null,
          child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  alert!.status.confirmationLabel ?? 'Resolved',
                  style: theme.textTheme.bodySmall,
                ),
              ),
        ),
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Row(
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            spacing: 12,
            children: [
              _HeaderColumn(
                crossAxisAlignment: .center,
                child1: Align(
                  alignment: .bottomCenter,
                  child: Text('Now', style: theme.textTheme.labelSmall),
                ),
                child2: Assets.icons.alertWithResident.designImage(
                  height: 45,
                  width: 45,
                ),
              ),
              _HeaderColumn(
                child1: Text(
                  alert!.alertType.label,
                  style: theme.textTheme.headlineLarge!.copyWith(
                    color: AppTheme.fail,
                  ),
                ),
                child2: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'at ${alert!.address}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      'by ${alert!.senderName}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderColumn extends StatelessWidget {
  final Widget child1;
  final Widget child2;
  final CrossAxisAlignment? crossAxisAlignment;
  const _HeaderColumn({
    super.key,
    required this.child1,
    required this.child2,
    this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      mainAxisAlignment: .start,
      crossAxisAlignment: crossAxisAlignment ?? .start,
      children: [
        SizedBox(height: 20, child: child1),
        SizedBox(height: 50, child: child2),
      ],
    );
  }
}
