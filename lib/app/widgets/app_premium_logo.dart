import 'dart:ui';

import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_media_resources.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppPremiumLogo extends StatelessWidget {
  const AppPremiumLogo({
    this.size = 32,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        SvgPicture.asset(
          AppMediaRes.appLogo,
          width: size,
          height: size,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'bouldee',
              style: context.textTheme.headlineMedium?.copyWith(
                color: AppColors.textLight,
                fontSize: size * 0.75,
                height: 0.9,
              ),
            ),
            Text(
              'summit',
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: size * 0.35,
                height: 0.9,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
