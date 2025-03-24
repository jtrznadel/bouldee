import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/widgets/app_tile.dart';
import 'package:bouldee/features/home/presentation/widgets/activity_chart.dart';
import 'package:bouldee/features/home/presentation/widgets/stats_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeMiniStats extends StatelessWidget {
  const HomeMiniStats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        spacing: 10,
        children: [
          Expanded(
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: AppTile(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Poziom',
                          style: context.textTheme.labelLarge?.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '7B',
                              style: context.textTheme.headlineLarge?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 80,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                LucideIcons.chevronsUp,
                                size: 36,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: AppTile(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Skuteczność',
                          style: context.textTheme.labelLarge?.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Expanded(
                          child: BoulderStatsChart(
                            flashPercentage: 0.45,
                            topPercentage: 0.35,
                            projektPercentage: 0.20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AppTile(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    'Systematyczność',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                  Expanded(
                    child: ActivityChart(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
