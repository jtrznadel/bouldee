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
    this.isSmall = false,
    super.key,
    this.iconPath,
  });

  factory AppButton.small({
    required VoidCallback onPressed,
    String? text,
    String? iconPath,
    Color color = AppColors.primary,
    Color textColor = AppColors.textPrimary,
    bool isSmall = true,
    Key? key,
  }) {
    return AppButton(
      onPressed: onPressed,
      text: text,
      iconPath: iconPath,
      color: color,
      textColor: textColor,
      key: key,
      isSmall: isSmall,
    );
  }

  final Color color;
  final Color textColor;
  final String? text;
  final String? iconPath;
  final VoidCallback onPressed;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: isSmall ? 8 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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
                  style: isSmall
                      ? context.textTheme.labelSmall
                      : context.textTheme.labelMedium,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
