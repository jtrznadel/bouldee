import 'dart:math' as Math;

import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_media_resources.dart';
import 'package:bouldee/app/constants/app_sizes.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/features/profile/presentation/views/profile_achivements_section.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const userLevel = 24;
    const progressToNextLevel = 0.26;
    const points = 7500;
    const pointsToNextLevel = 10000;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: context.textTheme.labelLarge?.copyWith(
            color: AppColors.textLight,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.defaultHorizontalPadding,
        ),
        child: Column(
          children: [
            _buildAdvancedLevelAvatar(
              context,
              level: userLevel,
              progress: progressToNextLevel,
              points: points,
              pointsToNextLevel: pointsToNextLevel,
            ),
            const SizedBox(height: 20),
            Text(
              'Jakub Czandelovsky',
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.textLight,
              ),
            ),
            Text(
              '@czandelovsky',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Lorem ipsum dolor sit amet',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileStatisticTile(title: 'Problemy', value: 67),
                ProfileStatisticTile(title: 'Flashe', value: 13),
                ProfileStatisticTile(title: 'Sesje', value: 23),
              ],
            ),
            const SizedBox(height: 20),
            const ProfileAchivementsSection(),
          ],
        ),
      ),
    );
  }
}

class ProfileStatisticTile extends StatelessWidget {
  const ProfileStatisticTile({
    required this.value,
    required this.title,
    super.key,
  });

  final int value;
  final String title;

  @override
  Widget build(BuildContext context) {
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
              value.toString(),
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

class LevelProgressPainter extends CustomPainter {
  LevelProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    this.strokeWidth = 6.0,
  });
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -Math.pi / 2,
      2 * Math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(LevelProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

Widget _buildAdvancedLevelAvatar(
  BuildContext context, {
  required int level,
  required double progress,
  required int points,
  required int pointsToNextLevel,
  double radius = 64,
}) {
  return Stack(
    alignment: Alignment.center,
    children: [
      SizedBox(
        width: radius * 2 + 20,
        height: radius * 2 + 20,
        child: CustomPaint(
          painter: LevelProgressPainter(
            progress: progress,
            progressColor: AppColors.primary,
            backgroundColor: AppColors.primary.withValues(alpha: .2),
          ),
        ),
      ),
      Container(
        width: radius * 2 + 4,
        height: radius * 2 + 4,
        decoration: const BoxDecoration(
          color: AppColors.background,
          shape: BoxShape.circle,
        ),
      ),
      CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primary,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.asset(
            AppMediaRes.deffaultAvatar,
            fit: BoxFit.cover,
            width: radius * 2,
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.background, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .4),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                LucideIcons.flame,
                size: 16,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                'LVL $level',
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
