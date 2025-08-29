import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/widgets/app_section_header.dart';
import 'package:bouldee/app/widgets/app_tile.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeLastSession extends StatelessWidget {
  const HomeLastSession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSectionHeader(
          title: 'Ostatnia sesja',
          buttonText: 'Zobacz więcej',
          onButtonPressed: () {},
        ),
        AppTile(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      LucideIcons.mountain,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Block Bouldercenter',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '21 marca, 19:30-21:45',
                          style: context.textTheme.labelMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '2h 15m',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppColors.surface),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSessionStat(
                    context,
                    'ALL',
                    '14',
                    Icons.check_circle_outline,
                  ),
                  _buildSessionStat(context, 'FLASH', '6', LucideIcons.zap),
                  _buildSessionStat(
                    context,
                    'TOP',
                    '5',
                    LucideIcons.checkCheck,
                  ),
                  _buildSessionStat(context, 'PROJEKT', '3', LucideIcons.timer),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDifficultyIndicator(
                      context,
                      'V1-V3',
                      5,
                      AppColors.primary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDifficultyIndicator(
                      context,
                      'V4-V5',
                      7,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDifficultyIndicator(
                      context,
                      'V6+',
                      2,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildSessionStat(
  BuildContext context,
  String label,
  String value,
  IconData icon,
) {
  return Column(
    children: [
      Icon(icon, color: AppColors.primary, size: 22),
      const SizedBox(height: 5),
      Text(
        value,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    ],
  );
}

Widget _buildDifficultyIndicator(
  BuildContext context,
  String label,
  int count,
  Color color,
) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        '$count ✕',
        style: context.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
