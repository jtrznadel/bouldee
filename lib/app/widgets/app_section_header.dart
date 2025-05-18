import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    super.key,
    this.buttonText,
    this.onButtonPressed,
  });

  final String title;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.labelLarge
              ?.copyWith(color: AppColors.textLight),
        ),
        if (buttonText != null && onButtonPressed != null)
          TextButton(
            onPressed: onButtonPressed,
            child: Text(
              buttonText!,
              style: context.textTheme.labelMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
      ],
    );
  }
}
