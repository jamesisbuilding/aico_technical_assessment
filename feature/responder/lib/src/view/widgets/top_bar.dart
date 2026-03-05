import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  List<Widget> _buildActionIcons() {
    return [
      Assets.icons.personIcon.designImage(height: 19, width: 19),
      Assets.icons.settings.designImage(height: 17, width: 17),
    ];
  }

  Widget _buildLogoAndText({required BuildContext context}) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 12,
      children: [
        Assets.icons.plusButton.designImage(height: 30, width: 30),
        Row(
          spacing: 12,
          children: [
            Assets.icons.logo.designImage(height: 34, width: 33),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text('Hello, Michelle!', style: Theme.of(context).textTheme.headlineMedium,),
                Text('see your alerts below', style: Theme.of(context).textTheme.bodyMedium,),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Padding(
        padding: const .all(20),
        child: Row(
          spacing: 12,
          children: [_buildLogoAndText(context: context), Spacer(), ..._buildActionIcons()],
        ),
      ),
    );
  }
}
