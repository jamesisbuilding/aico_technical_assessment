import 'package:aico_test/di/service_locator.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'app_router/router.dart';

void main() {
  registerServices(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aico',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: AppRouter.router,
    );
  }
}
