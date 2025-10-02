import 'package:bouldee/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppPageIndicator extends StatefulWidget {
  const AppPageIndicator({
    required this.totalPages,
    required this.pageController,
    super.key,
  });

  final int totalPages;
  final PageController pageController;

  @override
  State<AppPageIndicator> createState() => _AppPageIndicatorState();
}

class _AppPageIndicatorState extends State<AppPageIndicator> {
  double currentPage = 0;

  @override
  void initState() {
    widget.pageController.addListener(_onPageChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    if (widget.pageController.hasClients) {
      final newPage = widget.pageController.page ?? 0;
      if (newPage != currentPage) {
        setState(() {
          currentPage = newPage;
        });
      }
    }
  }

  double _getIndicatorWidth(int index) {
    const normalWidth = 8.0;
    const activeWidth = 12.0;

    final distance = (currentPage - index).abs();

    if (distance <= 1.0) {
      if (distance == 0.0) {
        return activeWidth;
      } else {
        final progress = 1.0 - distance;
        return normalWidth + (activeWidth - normalWidth) * progress;
      }
    }

    return normalWidth;
  }

  Color _getIndicatorColor(int index) {
    const fadeDistance = 1.5;
    final distance = (currentPage - index).abs();

    if (distance <= fadeDistance) {
      final opacity = distance <= 1.0 ? 1.0 - (distance * 0.7) : 0.3;

      return AppColors.primary.withValues(alpha: opacity);
    }

    return AppColors.primary.withValues(alpha: 0.3);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: List.generate(
          widget.totalPages,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _getIndicatorWidth(index),
            height: 8,
            decoration: BoxDecoration(
              color: _getIndicatorColor(index),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
