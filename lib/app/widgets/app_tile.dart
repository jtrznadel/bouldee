import 'package:bouldee/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    required this.child,
    super.key,
    this.color = AppColors.onSurface,
    this.innerPadding,
    this.outerPadding,
  });

  final Color color;
  final Widget child;
  final EdgeInsetsGeometry? innerPadding;
  final EdgeInsetsGeometry? outerPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: outerPadding ?? EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: innerPadding ??
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: child,
      ),
    );
  }
}
