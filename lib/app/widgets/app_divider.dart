import 'package:bouldee/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    required this.width,
    required this.height,
    super.key,
    this.text,
  });

  factory AppDivider.vertical({
    String width = '1',
    String height = '100%',
  }) {
    return AppDivider(
      width: width,
      height: height,
    );
  }

  factory AppDivider.horizontal({
    String width = '100%',
    String height = '1',
  }) {
    return AppDivider(
      width: width,
      height: height,
    );
  }

  factory AppDivider.horizontalWithText({
    required String text,
    String width = '100%',
    String height = '1',
  }) {
    return AppDivider(
      width: width,
      height: height,
      text: text,
    );
  }

  final String width;
  final String height;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
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
