import 'dart:math';
import 'package:flutter/material.dart';

class RingProgressIndicator extends StatelessWidget {
  const RingProgressIndicator({
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
    super.key,
    this.strokeWidth = 10.0,
    this.size = 100.0,
    this.child,
  });
  final double value;
  final Color backgroundColor;
  final Color valueColor;
  final double strokeWidth;
  final double size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              value: value,
              backgroundColor: backgroundColor,
              valueColor: valueColor,
              strokeWidth: strokeWidth,
            ),
          ),
          if (child != null) Center(child: child),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
    required this.strokeWidth,
  });
  final double value;
  final Color backgroundColor;
  final Color valueColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = valueColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * value;
    const startAngle = -pi / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.valueColor != valueColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
