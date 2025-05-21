import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({required this.color, required this.content, super.key});

  final Color color;
  final Widget content;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: content,
    );
  }
}
