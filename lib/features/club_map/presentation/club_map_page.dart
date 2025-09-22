import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_media_resources.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';
import 'package:bouldee/app/utilities/boulder_utils.dart';
import 'package:bouldee/app/widgets/app_button.dart';
import 'package:bouldee/app/widgets/app_loading_indicator.dart';
import 'package:bouldee/features/boulder_details/presentation/bloc/boulder_details_bloc.dart';
import 'package:bouldee/features/club_map/domain/entities/area_entity.dart';
import 'package:bouldee/features/club_map/domain/entities/boulder_entity.dart';
import 'package:bouldee/features/club_map/presentation/bloc/club_map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class ClubMapPage extends StatelessWidget {
  const ClubMapPage({
    @PathParam('clubId') required this.clubId,
    super.key,
  });

  final String clubId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ClubMapBloc>()..add(LoadClubMapData(clubId: clubId)),
      child: _ClubMapView(),
    );
  }
}

class _ClubMapView extends StatefulWidget {
  @override
  State<_ClubMapView> createState() => _ClubMapViewState();
}

class _ClubMapViewState extends State<_ClubMapView> {
  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clubId =
        (context.findAncestorWidgetOfExactType<ClubMapPage>()!).clubId;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BlocBuilder<ClubMapBloc, ClubMapState>(
              builder: (context, state) {
                if (state is ClubMapLoading) {
                  return const Center(child: AppLoadingIndicator());
                } else if (state is AreaError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ClubMapBloc>().add(
                                  LoadClubMapData(clubId: clubId),
                                );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is ClubMapLoaded) {
                  return Column(
                    children: [
                      Expanded(
                        child: InteractiveViewer(
                          transformationController: _transformationController,
                          minScale: 0.2,
                          maxScale: 3,
                          constrained: false,
                          onInteractionUpdate: (details) {
                            setState(() {
                              _currentScale = _transformationController.value
                                  .getMaxScaleOnAxis();
                            });
                          },
                          child: Center(
                            child: Stack(
                              children: [
                                _buildGymLayout(state.areas),
                                ..._buildBoulderMarkers(state.boulders),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: ShapeDecoration(
                color: AppColors.onSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                spacing: 4,
                children: [
                  const Icon(
                    LucideIcons.filter,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                  Text(
                    'Filtry',
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.textLight),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGymLayout(List<AreaEntity> areas) {
    return Container(
      width: 1000,
      height: 800,
      color: AppColors.surface,
      child: CustomPaint(
        painter: GymLayoutPainter(
          areas: areas,
          scale: _currentScale,
        ),
      ),
    );
  }

  List<Widget> _buildBoulderMarkers(List<BoulderEntity> boulders) {
    final markers = <Widget>[];

    for (final boulder in boulders) {
      markers.add(
        Positioned(
          left: boulder.x,
          top: boulder.y,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: BlocProvider(
                    create: (_) => getIt<BoulderDetailsBloc>()
                      ..add(GetBoulderDetailsEvent(boulderId: boulder.id)),
                    child: const BoulderDetailsPreview(),
                  ),
                ),
              );
            },
            child: Container(
              width: 24 / _currentScale,
              height: 24 / _currentScale,
              decoration: BoxDecoration(
                color: BoulderUtils.getDifficultyColor(boulder.grade),
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.white, width: 2 / _currentScale),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .3),
                    spreadRadius: 1 / _currentScale,
                    blurRadius: 3 / _currentScale,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  boulder.grade,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10 / _currentScale,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }
}

class GradeBadge extends StatelessWidget {
  const GradeBadge({
    required this.grade,
    required this.color,
    super.key,
  });

  final String grade;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        grade,
        style: context.textTheme.labelMedium?.copyWith(
          color: AppColors.textLight,
        ),
      ),
    );
  }
}

class GymLayoutPainter extends CustomPainter {
  GymLayoutPainter({required this.areas, required this.scale});
  final List<AreaEntity> areas;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final areaPaint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 / scale;

    for (final area in areas) {
      final points = area.points;
      final path = Path();

      if (points.isNotEmpty) {
        path.moveTo(points[0][0], points[0][1]);

        for (var i = 1; i < points.length; i++) {
          path.lineTo(points[i][0], points[i][1]);
        }
        path.close();

        canvas
          ..drawPath(path, areaPaint)
          ..drawPath(path, borderPaint);

        final textSpan = TextSpan(
          text: area.label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16 / scale,
            fontWeight: FontWeight.bold,
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();

        double centerX = 0;
        double centerY = 0;
        for (final point in points) {
          centerX += point[0];
          centerY += point[1];
        }
        centerX /= points.length;
        centerY /= points.length;

        textPainter.paint(
          canvas,
          Offset(
            centerX - textPainter.width / 2,
            centerY - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BoulderDetailsPreview extends StatelessWidget {
  const BoulderDetailsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoulderDetailsBloc, BoulderDetailsState>(
      listener: (context, state) {
        if (state is BoulderDetailsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is BoulderDetailsLoading) {
          return const AppLoadingIndicator();
        } else if (state is BoulderDetailsLoaded) {
          final boulderDetails = state.boulderDetails;
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .3),
                  spreadRadius: 2,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      if (boulderDetails.imageUrl != null)
                        Image.network(
                          boulderDetails.imageUrl!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            AppMediaRes.deffaultBoulderImage,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Image.asset(
                          AppMediaRes.deffaultBoulderImage,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.onSurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              LucideIcons.x,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        boulderDetails.name,
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        boulderDetails.description ?? '...',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppButton.small(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.router.push(
                            BoulderDetailsRoute(
                              boulderId: boulderDetails.id,
                            ),
                          );
                        },
                        text: 'Zobacz więcej',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
