import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CurrentTrainingSessionPage extends StatelessWidget {
  const CurrentTrainingSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text(
          'Current Training Session',
          style: context.textTheme.headlineLarge?.copyWith(
            color: AppColors.textLight,
          ),
        ),
      ),
    );
  }
}
