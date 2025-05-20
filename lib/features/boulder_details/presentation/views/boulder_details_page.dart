import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_media_resources.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/utilities/boulder_utils.dart';
import 'package:bouldee/app/widgets/app_loading_indicator.dart';
import 'package:bouldee/app/widgets/app_statistic_tile.dart';
import 'package:bouldee/features/boulder_details/presentation/bloc/boulder_details_bloc.dart';
import 'package:bouldee/features/club_map/presentation/club_map_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class BoulderDetailsPage extends StatelessWidget {
  const BoulderDetailsPage({required this.boulderId, super.key});

  final String boulderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BoulderDetailsBloc>()
        ..add(GetBoulderDetailsEvent(boulderId: boulderId)),
      child: Scaffold(
        body: BlocBuilder<BoulderDetailsBloc, BoulderDetailsState>(
          builder: (context, state) {
            if (state is BoulderDetailsLoading ||
                state is BoulderDetailsInitial) {
              return const Center(
                child: AppLoadingIndicator(),
              );
            } else if (state is BoulderDetailsError) {
              return SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LucideIcons.badgeAlert,
                        size: 48,
                        color: AppColors.errorColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nie udało się załadować szczegółów',
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.errorColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<BoulderDetailsBloc>()
                            .add(GetBoulderDetailsEvent(boulderId: boulderId)),
                        child: const Text('Spróbuj ponownie'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is BoulderDetailsLoaded) {
              final boulderDetails = state.boulderDetails;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.background,
                  title: Text(
                    boulderDetails.name,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.router.maybePop(),
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GradeBadge(
                              grade: boulderDetails.grade,
                              color: BoulderUtils.getDifficultyColor(
                                boulderDetails.grade,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                boulderDetails.name,
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: AppColors.textLight,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (boulderDetails.rating != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      boulderDetails.rating!.toStringAsFixed(1),
                                      style: context.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Icon(
                                      Icons.star_rate_rounded,
                                      color: AppColors.secondary,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Setter: ${boulderDetails.setter}',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: boulderDetails.imageUrl != null
                                ? Image.network(
                                    boulderDetails.imageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          LucideIcons.imageOff,
                                          color: AppColors.textSecondary,
                                          size: 36,
                                        ),
                                      );
                                    },
                                  )
                                : Image.asset(
                                    AppMediaRes.deffaultBoulderImage,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          LucideIcons.imageOff,
                                          color: AppColors.textSecondary,
                                          size: 36,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: AppColors.textSecondary),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AppStatisticTile(
                              title: 'Flash',
                              value: boulderDetails.flash,
                            ),
                            AppStatisticTile(
                              title: 'Top',
                              value: boulderDetails.top,
                            ),
                            AppStatisticTile(
                              title: 'Średnia prób',
                              value: boulderDetails.attemptsAvg,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: AppColors.textSecondary),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Ocena trudności ~ ',
                              style: context.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            ),
                            GradeBadge(
                              grade: boulderDetails.grade,
                              color: BoulderUtils.getDifficultyColor(
                                boulderDetails.grade,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  const Icon(
                                    LucideIcons.info,
                                    color: AppColors.textSecondary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Jak to działa?',
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 80,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: [
                                for (int i = 1; i <= 8; i++)
                                  BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: i * 10.0,
                                        color: AppColors.primary,
                                        width: 32,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(6),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: const AxisTitles(),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      final grade = 'V${value.toInt()}';

                                      return Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                BoulderUtils.getDifficultyColor(
                                              boulderDetails.grade,
                                            ),
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              bottom: Radius.circular(6),
                                            ),
                                          ),
                                          child: Text(
                                            grade,
                                            style: context.textTheme.labelSmall
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(),
                                rightTitles: const AxisTitles(),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: false),
                            ),
                          ),
                        ),
                        if (boulderDetails.description != null) ...[
                          const SizedBox(height: 16),
                          const Divider(color: AppColors.textSecondary),
                          const SizedBox(height: 10),
                          Text(
                            'Opis',
                            style: context.textTheme.labelLarge?.copyWith(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            boulderDetails.description!,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }

            return const SafeArea(
              child: Center(
                child: AppLoadingIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
