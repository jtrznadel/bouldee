import 'package:bouldee/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.text,
    this.verticalPadding,
    this.horizontalPadding,
  });

  factory AppDivider.horizontalWithText({
    required String text,
    EdgeInsets? padding,
  }) {
    return AppDivider(
      text: text,
      verticalPadding: padding?.vertical,
      horizontalPadding: padding?.horizontal,
    );
  }

  final String? text;
  final double? verticalPadding;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding ?? 10,
        horizontal: horizontalPadding ?? 0,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: AppColors.textSecondary,
            ),
          ),
          if (text != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                text!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          const Expanded(
            child: Divider(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
