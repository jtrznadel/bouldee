import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_sizes.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class AppStatisticTile extends StatelessWidget {
  const AppStatisticTile({
    required this.value,
    required this.title,
    super.key,
  });

  final num value;
  final String title;

  @override
  Widget build(BuildContext context) {
    final displayValue =
        value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(AppSizes.defaultRadius),
        ),
        child: Column(
          children: [
            Text(
              displayValue,
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.textLight,
              ),
            ),
            Text(
              title,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
