import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: SafeArea(
        child: Row(
          spacing: 35,
          mainAxisAlignment: .center,
          children: [
            Assets.icons.liveIcon.designImage(height: 27, width: 50),
            Assets.icons.summaryIcon.designImage(height: 30, width: 50)
          ],
        ),
      ),
    );
  }
}