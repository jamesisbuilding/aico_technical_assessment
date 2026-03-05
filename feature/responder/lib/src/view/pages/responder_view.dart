import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:responder/src/view/widgets/bottom_bar.dart';
import 'package:responder/src/view/widgets/responder_card/responder_alert_widget.dart';
import 'package:responder/src/view/widgets/top_bar.dart';

class ResponderView extends StatelessWidget {
  const ResponderView({super.key});

  static MaterialPage get page => MaterialPage(child: ResponderView());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          bottom: false,
          child: Stack(
            alignment: .center,
            children: [
              Column(
                children: [
                  const TopBar(),
                  Expanded(child: ResponderAlertCard()),
                ],
              ),
              const BottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}


  // 