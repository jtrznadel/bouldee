import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    this.color = AppColors.primary,
    this.textColor = AppColors.textPrimary,
    super.key,
  });

  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(999),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(
            child: Text(
              text,
              style: context.textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }
}
