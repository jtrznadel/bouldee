import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_sizes.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SubscriptionTypeTile extends StatelessWidget {
  const SubscriptionTypeTile({
    required this.type,
    required this.price,
    required this.isSelected,
    required this.onTap,
    this.discounted = false,
    this.freeTrialPossible = false,
    this.description,
    super.key,
  });

  final String type;
  final String price;
  final bool isSelected;
  final bool discounted;
  final bool freeTrialPossible;
  final String? description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = (MediaQuery.of(context).size.width -
            (2 * AppSizes.defaultHorizontalPadding) -
            24) /
        2;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.onSurface,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                      Text(
                        price,
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (isSelected)
                    const Icon(
                      LucideIcons.badgeCheck,
                      size: 24,
                      color: AppColors.primary,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 24,
                child: discounted
                    ? Container(
                        width: size * .6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.onSurface,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '20% zniżki',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              if (freeTrialPossible)
                Row(
                  children: [
                    const Icon(
                      LucideIcons.gift,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '7 dni za darmo',
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                )
              else if (description != null)
                Text(
                  description!,
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
