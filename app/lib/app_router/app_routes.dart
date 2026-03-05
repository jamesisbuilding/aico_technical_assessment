import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:responder/responder.dart';

sealed class AppRoutes {
  static const String responder = '/';

  static List<GoRoute> get routes => <GoRoute>[
        GoRoute(
          path: AppRoutes.responder,
          name: 'responder',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return ResponderFlow.page;
          },
        ),
      ];
}

