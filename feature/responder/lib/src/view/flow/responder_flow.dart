import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:responder/src/view/bloc/responder_bloc.dart';
import 'package:responder/src/view/bloc/responder_event.dart';

import '../pages/responder_view.dart';

enum ResponderStep { responder }

class ResponderFlow extends StatelessWidget {
  const ResponderFlow({super.key});

  static MaterialPage get page => MaterialPage(child: ResponderFlow());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ResponderBloc>()..add(StreamAlertsEvent()),
      child: FlowBuilder<ResponderStep>(
        state: ResponderStep.responder,
        onGeneratePages: (ResponderStep state, List<Page<dynamic>> pages) {
          switch (state) {
            case ResponderStep.responder:
              return <Page<dynamic>>[ResponderView.page];
          }
        },
      ),
    );
  }
}
