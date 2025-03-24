import 'package:bouldee/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    required this.child,
    super.key,
    this.color = AppColors.tileColor,
    this.padding,
  });

  final Color color;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: padding ?? const EdgeInsets.all(15),
      child: child,
    );
  }
}
