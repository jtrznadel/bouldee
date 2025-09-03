import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_media_resources.dart';
import 'package:bouldee/app/constants/app_sizes.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/utilities/boulder_utils.dart';
import 'package:bouldee/app/widgets/app_badge.dart';
import 'package:bouldee/app/widgets/app_divider.dart';
import 'package:bouldee/app/widgets/app_section_header.dart';
import 'package:bouldee/app/widgets/app_statistic_tile.dart';
import 'package:bouldee/features/auth/presentation/bloc/auth_bloc.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.4;
    // Pokazuj tytuł gdy zescrollujemy więcej niż połowę obrazka
    final showTitle = _scrollController.hasClients &&
        _scrollController.offset >
            (imageHeight - kToolbarHeight - MediaQuery.of(context).padding.top);

    if (showTitle != _showTitle) {
      setState(() {
        _showTitle = showTitle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.4;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // SliverAppBar ze zdjęciem
          SliverAppBar(
            expandedHeight: imageHeight,
            pinned: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  LucideIcons.chevronLeft,
                  color: Colors.white,
                ),
                onPressed: () => context.router.maybePop(),
              ),
            ),
            title: AnimatedOpacity(
              opacity: _showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                widget.boulderDetails.name,
                style: context.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.boulderDetails.imageUrl != null)
                    Image.network(
                      widget.boulderDetails.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppMediaRes.deffaultBoulderImage,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  else
                    Image.asset(
                      AppMediaRes.deffaultBoulderImage,
                      fit: BoxFit.cover,
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Nagłówek z informacjami
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GradeBadge(
                    grade: widget.boulderDetails.grade,
                    color: BoulderUtils.getDifficultyColor(
                      widget.boulderDetails.grade,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.boulderDetails.name,
                          style: context.textTheme.labelLarge?.copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Setter: ${widget.boulderDetails.setter}',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.boulderDetails.rating != null)
                    AppBadge(
                      color: AppColors.primary,
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.boulderDetails.rating!.toStringAsFixed(1),
                            style: context.textTheme.labelMedium?.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.star_rate_rounded,
                            color: AppColors.textDark,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Główna zawartość
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statystyki
                  Row(
                    children: [
                      AppStatisticTile(
                        title: 'Flash',
                        value: widget.boulderDetails.flash,
                        isPercent: true,
                      ),
                      const SizedBox(width: 10),
                      AppStatisticTile(
                        title: 'Top',
                        value: widget.boulderDetails.top,
                        isPercent: true,
                      ),
                      const SizedBox(width: 10),
                      AppStatisticTile(
                        title: 'Średnia prób',
                        value: widget.boulderDetails.attemptsAvg,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Ocena trudności
                  Row(
                    children: [
                      const AppSectionHeader(title: 'Ocena trudności ~ '),
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
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Jak to działa?',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Wykres
                  SizedBox(
                    height: 120,
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
                                  width: 24,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
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
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                final grade = 'V${value.toInt()}';
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: BoulderUtils.getDifficultyColor(
                                        widget.boulderDetails.grade,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
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

                  // Opis
                  if (widget.boulderDetails.description != null) ...[
                    const SizedBox(height: 24),
                    const AppSectionHeader(title: 'Opis'),
                    const SizedBox(height: 8),
                    Text(
                      widget.boulderDetails.description!,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],

                  // Ranking - podium
                  const SizedBox(height: 24),
                  const AppSectionHeader(title: 'Ranking'),

                  // Podium
                  const SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        LeaderboardAvatar(
                          position: 1,
                          color: Colors.grey,
                          radius: 50,
                        ),
                        SizedBox(width: 8),
                        LeaderboardAvatar(
                          position: 1,
                          color: Colors.amber,
                          radius: 60,
                        ),
                        SizedBox(width: 8),
                        LeaderboardAvatar(
                          position: 3,
                          color: Colors.brown,
                          radius: 40,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  AppDivider.horizontal(),

                  // Lista rankingu
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final position = index + 4;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  '$position',
                                  style:
                                      context.textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const LeaderboardAvatar(
                              radius: 20,
                              position: 4,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Użytkownik $position',
                                    style:
                                        context.textTheme.labelMedium?.copyWith(
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                  Text(
                                    'Ocena: ${(10 - position).toStringAsFixed(1)}',
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              LucideIcons.star,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardAvatar extends StatelessWidget {
  const LeaderboardAvatar({
    required this.color,
    required this.position,
    required this.radius,
    super.key,
  });

  final int position;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 3,
            ),
          ),
          child: CircleAvatar(
            backgroundColor: AppColors.surface,
            radius: radius,
            backgroundImage: const AssetImage(
              AppMediaRes.deffaultAvatar,
            ),
          ),
        ),
        Positioned(
          bottom: -10,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '$position',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
