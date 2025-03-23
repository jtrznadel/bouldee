import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    this.text,
    this.color = AppColors.primary,
    this.textColor = AppColors.textPrimary,
    super.key,
    this.iconPath,
  });

  final Color color;
  final Color textColor;
  final String? text;
  final String? iconPath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
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
                  style: context.textTheme.labelLarge,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
