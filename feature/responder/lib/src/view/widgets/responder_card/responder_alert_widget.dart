import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responder/src/domain/model/alert_entity.dart';
import 'package:responder/src/view/bloc/responder_bloc.dart';
import 'package:responder/src/view/bloc/responder_event.dart';
import 'package:responder/src/view/bloc/responder_state.dart';
import 'package:responder/src/view/widgets/responder_card/responder_alert_header.dart';
import 'package:responder/src/view/widgets/responder_card/responder_body.dart';

class ResponderAlertCard extends StatefulWidget {
  const ResponderAlertCard({super.key});

  @override
  State<ResponderAlertCard> createState() => _ResponderAlertCardState();
}

class _ResponderAlertCardState extends State<ResponderAlertCard> {
  bool _expanded = false;
  bool _shouldExit = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _toggleExit() async {
    setState(() {
      _shouldExit = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    context.read<ResponderBloc>().add(UpdateAlertEvent(alert: null));

    setState(() {
      _expanded = false;
      _shouldExit = false;
    });
  }

  Future<void> _toggleExpanded() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ResponderBloc, ResponderState>(
      buildWhen: (prev, curr) => prev.currentAlert != curr.currentAlert,
      builder: (context, state) {
        final double height = state.currentAlert?.status == AlertStatus.resolved
            ? 394
            : _expanded
            ? 476
            : 137;
        final Color alertColor =
            state.currentAlert?.status.color ?? AppTheme.primary;

        final Offset offset = state.currentAlert != null && !_shouldExit
            ? Offset(0, 0)
            : Offset(1, 0);

        if (state.currentAlert != null && !_expanded && !_shouldExit) {
          _toggleExpanded();
        }
        return AnimatedSlide(
          duration: const Duration(milliseconds: 250),
          offset: offset,
          curve: animationCurve,
          child: state.currentAlert == null
              ? const SizedBox()
              : Padding(
                padding: const .symmetric(horizontal: 16, vertical: 36),
                child: SingleChildScrollView(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: animationCurve,
                    height: height,
                    decoration: BoxDecoration(
                      border: .all(color: alertColor),
                      borderRadius: .circular(10),
                      color: theme.colorScheme.surface,
                    ),
                    child: Row(
                      crossAxisAlignment: .start,
                      children: [
                        Container(
                          width: 11,
                          decoration: BoxDecoration(
                            color: alertColor,
                            borderRadius: .only(
                              topLeft: .circular(8.8),
                              bottomLeft: .circular(8.8),
                            ),
                          ),
                        ),
              
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              spacing: 40,
                              mainAxisAlignment: .start,
                              children: [
                                ResponderAlertHeader(
                                  alert: state.currentAlert!,
                                ),
                                ResponderBody(
                                  visible:
                                      _expanded &&
                                      state.currentAlert?.status !=
                                          AlertStatus.idle,
                                  alert: state.currentAlert!,
                                  onActionTap: (rA) =>
                                      context.read<ResponderBloc>().add(
                                        HandleResponseAction(action: rA),
                                      ),
                                  onConfirmationComplete: () =>
                                      _toggleExit(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }
}
