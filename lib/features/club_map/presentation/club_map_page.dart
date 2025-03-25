import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/features/club_map/domain/entities/area_entity.dart';
import 'package:bouldee/features/club_map/domain/entities/boulder_entity.dart';
import 'package:bouldee/features/club_map/presentation/bloc/club_map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Block Bouldercenter',
          style: context.textTheme.labelLarge?.copyWith(
            color: AppColors.textLight,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.replay),
            onPressed: () {
              _transformationController.value = Matrix4.identity();
              setState(() {
                _currentScale = 1.0;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<ClubMapBloc, ClubMapState>(
        builder: (context, state) {
          if (state is ClubMapLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                    minScale: 0.5,
                    maxScale: 3,
                    constrained: false,
                    onInteractionUpdate: (details) {
                      setState(() {
                        _currentScale =
                            _transformationController.value.getMaxScaleOnAxis();
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
    );
  }

  Widget _buildGymLayout(List<AreaEntity> areas) {
    return Container(
      width: 1000, // Base width of our layout canvas
      height: 800, // Base height of our layout canvas
      color: Colors.grey.shade800,
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
      final boulderColor = _getDifficultyColor(boulder.grade);

      markers.add(
        Positioned(
          left: boulder.x,
          top: boulder.y,
          child: GestureDetector(
            onTap: () => _showBoulderDetails(boulder),
            child: Container(
              width: 24 / _currentScale,
              height: 24 / _currentScale,
              decoration: BoxDecoration(
                color: boulderColor,
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

  Color _getDifficultyColor(String grade) {
    // V-scale difficulty colors
    if (grade.startsWith('V1') ||
        grade.startsWith('V2') ||
        grade.startsWith('V3')) {
      return Colors.green;
    } else if (grade.startsWith('V4') || grade.startsWith('V5')) {
      return Colors.blue;
    } else if (grade.startsWith('V6') || grade.startsWith('V7')) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  void _showBoulderDetails(BoulderEntity boulder) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(boulder.grade),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    boulder.grade,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    boulder.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Setter: ${boulder.setter}',
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Flash', '${boulder.flash}%'),
                _buildStatColumn('Top', '${boulder.top}%'),
                _buildStatColumn(
                  'Attempts Avg',
                  boulder.attemptsAvg.toStringAsFixed(1),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to detailed page or log attempt
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Log Attempt',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
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

    // Draw each area
    for (final area in areas) {
      final points = area.points;
      final path = Path();

      if (points.isNotEmpty) {
        path.moveTo(points[0][0], points[0][1]);

        for (var i = 1; i < points.length; i++) {
          path.lineTo(points[i][0], points[i][1]);
        }
        path.close();

        // Fill and stroke the path
        canvas
          ..drawPath(path, areaPaint)
          ..drawPath(path, borderPaint);

        // Add label
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

        // Calculate center position for the text
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
