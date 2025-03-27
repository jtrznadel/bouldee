import 'package:bouldee/app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ActivityChart extends StatelessWidget {
  ActivityChart({super.key});

  final List<String> weekdays = ['PON', 'WT', 'ŚR', 'CZW', 'PT', 'SB', 'ND'];
  final List<double> activityPoints = [5, 12, 3, 18, 10, 8, 15];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value != value.roundToDouble() ||
                      value < 0 ||
                      value >= weekdays.length) {
                    return const SizedBox.shrink();
                  }

                  final index = value.toInt();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      weekdays[index],
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: weekdays.length - 1.0,
          minY: 0,
          maxY: 20,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                weekdays.length,
                (index) => FlSpot(index.toDouble(), activityPoints[index]),
              ),
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.primary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(
                      0.7,
                    ),
                    AppColors.primary.withOpacity(
                      0.1,
                    ),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  return LineTooltipItem(
                    '${touchedSpot.y.toInt()} pts',
                    const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
            getTouchLineStart: (data, index) => 0,
          ),
        ),
      ),
    );
  }
}
