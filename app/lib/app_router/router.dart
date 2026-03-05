import 'package:go_router/go_router.dart';

import 'app_routes.dart';

sealed class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.responder,
    routes: AppRoutes.routes,
  );
}

