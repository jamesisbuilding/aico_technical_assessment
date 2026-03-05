import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const PrimaryButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 8.0),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () => onTap(),
        child: Container(
          height: 51,
          width: 260,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: .all(color: Theme.of(context).colorScheme.primary, width: 2),
            borderRadius: .circular(16)
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(color: AppTheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
