import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_media_resources.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppCustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AppCustomAppbar({
    this.title = 'bouldee',
    this.showAppLogo = false,
    super.key,
    this.onBack,
    this.color = AppColors.textLight,
  });

  final VoidCallback? onBack;
  final String title;
  final bool showAppLogo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showAppLogo) ...[
            SvgPicture.asset(
              AppMediaRes.appLogo,
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: context.textTheme.headlineMedium?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(LucideIcons.chevronLeft),
        onPressed: () {
          context.router.maybePop();
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
