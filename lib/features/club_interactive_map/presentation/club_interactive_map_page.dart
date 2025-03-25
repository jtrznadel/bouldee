import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ClubInteractiveMapPage extends StatefulWidget {
  const ClubInteractiveMapPage({super.key});

  @override
  State<ClubInteractiveMapPage> createState() => _ClubInteractiveMapPageState();
}

class _ClubInteractiveMapPageState extends State<ClubInteractiveMapPage> {
  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1;

  // This would typically come from an API or data file
  final Map<String, dynamic> _gymData = gymLayoutData;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
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
                    _buildGymLayout(),
                    ..._buildBoulderMarkers(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGymLayout() {
    return Container(
      width: 1000, // Base width of our layout canvas
      height: 800, // Base height of our layout canvas
      color: Colors.grey.shade800,
      child: CustomPaint(
        painter: GymLayoutPainter(
          areas: List<Map<String, dynamic>>.from(_gymData['areas'] as List),
          scale: _currentScale,
        ),
      ),
    );
  }

  List<Widget> _buildBoulderMarkers() {
    final markers = <Widget>[];

    for (final boulder in _gymData['boulders'] as List) {
      final boulderColor = _getDifficultyColor(boulder['grade'] as String);

      // Convert x and y to double explicitly to prevent type errors
      final x = (boulder['x'] is int)
          ? (boulder['x'] as int).toDouble()
          : boulder['x'] as double;

      final y = (boulder['y'] is int)
          ? (boulder['y'] as int).toDouble()
          : boulder['y'] as double;

      markers.add(
        Positioned(
          left: x,
          top: y,
          child: GestureDetector(
            onTap: () => _showBoulderDetails(boulder as Map<String, dynamic>),
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
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1 / _currentScale,
                    blurRadius: 3 / _currentScale,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  boulder['grade'] as String,
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

  void _showBoulderDetails(Map<String, dynamic> boulder) {
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
                    color: _getDifficultyColor(boulder['grade'] as String),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    boulder['grade'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  boulder['name'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Setter: ${boulder['setter']}',
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Flash', '${boulder['stats']['flash']}%'),
                _buildStatColumn('Top', '${boulder['stats']['top']}%'),
                _buildStatColumn(
                  'Attempts Avg',
                  boulder['stats']['attemptsAvg'].toString(),
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
  final List<Map<String, dynamic>> areas;
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
      final points = area['points'] as List;
      final path = Path();

      if (points.isNotEmpty) {
        // Convert first point coordinates to double
        final firstPointX = _toDouble(points[0][0]);
        final firstPointY = _toDouble(points[0][1]);

        path.moveTo(firstPointX, firstPointY);

        for (var i = 1; i < points.length; i++) {
          // Convert subsequent point coordinates to double
          final pointX = _toDouble(points[i][0]);
          final pointY = _toDouble(points[i][1]);

          path.lineTo(pointX, pointY);
        }
        path.close();

        // Fill and stroke the path
        canvas.drawPath(path, areaPaint);
        canvas.drawPath(path, borderPaint);

        // Add label if provided
        if (area['label'] != null) {
          final textSpan = TextSpan(
            text: area['label'] as String,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16 / scale,
              fontWeight: FontWeight.bold,
            ),
          );

          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();

          // Calculate center position for the text
          double centerX = 0, centerY = 0;
          for (final point in points) {
            // Convert to double when calculating center
            centerX += _toDouble(point[0]);
            centerY += _toDouble(point[1]);
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
  }

  // Helper method to safely convert any numeric value to double
  double _toDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    }
    return 0; // Fallback value if conversion fails
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Sample data structure - in a real app this would be loaded from JSON
final gymLayoutData = {
  'areas': [
    {
      'label': 'Main Wall',
      'points': [
        [100, 100],
        [500, 100],
        [500, 300],
        [100, 300],
      ],
    },
    {
      'label': 'Cave',
      'points': [
        [600, 100],
        [900, 100],
        [900, 300],
        [700, 400],
        [600, 300],
      ],
    },
    {
      'label': 'Slab',
      'points': [
        [100, 400],
        [400, 400],
        [400, 600],
        [100, 600],
      ],
    },
    {
      'label': 'Training Area',
      'points': [
        [500, 400],
        [900, 400],
        [900, 600],
        [500, 600],
      ],
    },
    {
      'label': 'Beginner Area',
      'points': [
        [100, 650],
        [400, 650],
        [400, 750],
        [100, 750],
      ],
    }
  ],
  'boulders': [
    {
      'id': 1,
      'name': 'Dyno King',
      'grade': 'V5',
      'setter': 'Mike Johnson',
      'x': 200,
      'y': 150,
      'stats': {
        'flash': 20,
        'top': 65,
        'attemptsAvg': 5.2,
      },
    },
    {
      'id': 2,
      'name': 'Crimp Master',
      'grade': 'V7',
      'setter': 'Sarah Lee',
      'x': 300,
      'y': 250,
      'stats': {
        'flash': 5,
        'top': 40,
        'attemptsAvg': 8.5,
      },
    },
    {
      'id': 3,
      'name': "Beginner's Luck",
      'grade': 'V2',
      'setter': 'Tom Wilson',
      'x': 150,
      'y': 700,
      'stats': {
        'flash': 70,
        'top': 95,
        'attemptsAvg': 1.8,
      },
    },
    {
      'id': 4,
      'name': 'Overhang Challenge',
      'grade': 'V6',
      'setter': 'Anna Kim',
      'x': 750,
      'y': 200,
      'stats': {
        'flash': 10,
        'top': 55,
        'attemptsAvg': 7.3,
      },
    },
    {
      'id': 5,
      'name': 'Balance Act',
      'grade': 'V3',
      'setter': 'David Smith',
      'x': 250,
      'y': 500,
      'stats': {
        'flash': 45,
        'top': 85,
        'attemptsAvg': 3.1,
      },
    },
    {
      'id': 6,
      'name': 'Campus Power',
      'grade': 'V8',
      'setter': 'Lisa Wong',
      'x': 600,
      'y': 500,
      'stats': {
        'flash': 2,
        'top': 25,
        'attemptsAvg': 12.7,
      },
    },
    {
      'id': 7,
      'name': 'Slab Master',
      'grade': 'V4',
      'setter': 'John Doe',
      'x': 350,
      'y': 450,
      'stats': {
        'flash': 30,
        'top': 75,
        'attemptsAvg': 4.2,
      },
    },
    {
      'id': 8,
      'name': 'Roof Problem',
      'grade': 'V7',
      'setter': 'Emma Clark',
      'x': 800,
      'y': 250,
      'stats': {
        'flash': 8,
        'top': 45,
        'attemptsAvg': 9.1,
      },
    },
    {
      'id': 9,
      'name': 'Technique Test',
      'grade': 'V3',
      'setter': 'Alex Brown',
      'x': 200,
      'y': 550,
      'stats': {
        'flash': 40,
        'top': 80,
        'attemptsAvg': 3.5,
      },
    },
    {
      'id': 10,
      'name': 'Endurance Route',
      'grade': 'V5',
      'setter': 'Chris Taylor',
      'x': 700,
      'y': 500,
      'stats': {
        'flash': 15,
        'top': 60,
        'attemptsAvg': 6.8,
      },
    },
    {
      'id': 11,
      'name': 'Power Move',
      'grade': 'V6',
      'setter': 'Sam Rodriguez',
      'x': 400,
      'y': 200,
      'stats': {
        'flash': 12,
        'top': 50,
        'attemptsAvg': 7.0,
      },
    },
    {
      'id': 12,
      'name': 'Dynamo',
      'grade': 'V4',
      'setter': 'Pat Johnson',
      'x': 450,
      'y': 150,
      'stats': {
        'flash': 25,
        'top': 70,
        'attemptsAvg': 4.8,
      },
    },
    {
      'id': 13,
      'name': 'Easy Start',
      'grade': 'V1',
      'setter': 'Jamie Lee',
      'x': 280,
      'y': 700,
      'stats': {
        'flash': 85,
        'top': 98,
        'attemptsAvg': 1.2,
      },
    },
    {
      'id': 14,
      'name': 'Project X',
      'grade': 'V9',
      'setter': 'Robin Wang',
      'x': 850,
      'y': 150,
      'stats': {
        'flash': 1,
        'top': 15,
        'attemptsAvg': 15.3,
      },
    }
  ],
};
