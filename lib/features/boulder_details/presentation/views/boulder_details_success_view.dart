import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_media_resources.dart';
import 'package:bouldee/app/constants/app_sizes.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/utilities/boulder_utils.dart';
import 'package:bouldee/app/widgets/app_badge.dart';
import 'package:bouldee/app/widgets/app_statistic_tile.dart';
import 'package:bouldee/features/boulder_details/domain/entities/boulder_details_entity.dart';
import 'package:bouldee/features/club_map/presentation/club_map_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BoulderDetailsSuccessView extends StatefulWidget {
  const BoulderDetailsSuccessView({
    required this.boulderDetails,
    super.key,
  });

  final BoulderDetailsEntity boulderDetails;

  @override
  State<BoulderDetailsSuccessView> createState() =>
      _BoulderDetailsSuccessViewState();
}

class _BoulderDetailsSuccessViewState extends State<BoulderDetailsSuccessView> {
  bool _showTitle = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 40 && !_showTitle) {
      setState(() {
        _showTitle = true;
      });
    } else if (_scrollController.offset <= 40 && _showTitle) {
      setState(() {
        _showTitle = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.background,
              title: AnimatedOpacity(
                opacity: _showTitle ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  widget.boulderDetails.name,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.only(
                right: AppSizes.defaultHorizontalPadding,
              ),
              actions: [
                AnimatedOpacity(
                  opacity: _showTitle ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: GradeBadge(
                    grade: widget.boulderDetails.grade,
                    color: BoulderUtils.getDifficultyColor(
                      widget.boulderDetails.grade,
                    ),
                  ),
                ),
              ],
              leading: IconButton(
                icon: const Icon(LucideIcons.chevronLeft),
                onPressed: () => context.router.maybePop(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GradeBadge(
                          grade: widget.boulderDetails.grade,
                          color: BoulderUtils.getDifficultyColor(
                            widget.boulderDetails.grade,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.boulderDetails.name,
                            style: context.textTheme.labelLarge?.copyWith(
                              color: AppColors.textLight,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.boulderDetails.rating != null)
                          AppBadge(
                            color: AppColors.primary,
                            content: Row(
                              children: [
                                Text(
                                  widget.boulderDetails.rating!
                                      .toStringAsFixed(1),
                                  style: context.textTheme.labelSmall?.copyWith(
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
                      'Setter: ${widget.boulderDetails.setter}',
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
                        child: widget.boulderDetails.imageUrl != null
                            ? Image.network(
                                widget.boulderDetails.imageUrl!,
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
                          value: widget.boulderDetails.flash,
                        ),
                        AppStatisticTile(
                          title: 'Top',
                          value: widget.boulderDetails.top,
                        ),
                        AppStatisticTile(
                          title: 'Średnia prób',
                          value: widget.boulderDetails.attemptsAvg,
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
                          grade: widget.boulderDetails.grade,
                          color: BoulderUtils.getDifficultyColor(
                            widget.boulderDetails.grade,
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
                                style: context.textTheme.bodySmall?.copyWith(
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
                                    borderRadius: const BorderRadius.vertical(
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
                                        color: BoulderUtils.getDifficultyColor(
                                          widget.boulderDetails.grade,
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
                    if (widget.boulderDetails.description != null) ...[
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
                        widget.boulderDetails.description!,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
