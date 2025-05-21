import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    required this.onPressed,
    this.text,
    this.borderColor = AppColors.primary,
    this.backgroundColor = AppColors.background,
    this.textColor = AppColors.textLight,
    super.key,
    this.iconPath,
  });

  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final String? text;
  final String? iconPath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              if (iconPath != null)
                SvgPicture.asset(
                  iconPath!,
                  width: 24,
                  height: 24,
                ),
              if (text != null)
                Text(
                  text!,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: textColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
