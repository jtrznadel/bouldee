import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:bouldee/app/constants/app_colors.dart';

class BoulderStatsChart extends StatelessWidget {
  const BoulderStatsChart({
    required this.flashPercentage,
    required this.topPercentage,
    required this.projektPercentage,
    super.key,
  });

  final double flashPercentage;
  final double topPercentage;
  final double projektPercentage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 120,
        width: 120,
        child: PieChart(
          PieChartData(
            startDegreeOffset: 180,
            sectionsSpace: 2,
            centerSpaceRadius: 0,
            sections: [
              PieChartSectionData(
                value: flashPercentage * 100,
                title: 'F',
                titleStyle: context.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
                color: AppColors.primary.withValues(alpha: .7),
                radius: 55,
              ),
              PieChartSectionData(
                value: topPercentage * 100,
                title: 'T',
                titleStyle: context.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
                color: AppColors.primary.withValues(alpha: .2),
                radius: 55,
              ),
              PieChartSectionData(
                value: projektPercentage * 100,
                title: 'P',
                titleStyle: context.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
                color: AppColors.primary.withValues(alpha: .5),
                radius: 55,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
