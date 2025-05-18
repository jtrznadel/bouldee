import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_sizes.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/widgets/app_section_header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfileAchivementsSection extends StatelessWidget {
  const ProfileAchivementsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        const AppSectionHeader(
          title: 'Osiągnięcia',
        ),
        IntrinsicHeight(
          child: OverflowBox(
            maxWidth: context.width,
            child: SizedBox(
              height: 50,
              child: ListView.separated(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                  left: AppSizes.defaultHorizontalPadding,
                ),
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actionsPadding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.defaultHorizontalPadding,
                            ),
                            backgroundColor: AppColors.background,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      LucideIcons.trophy,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Pierwsza setka',
                                  style: context.textTheme.headlineMedium
                                      ?.copyWith(color: AppColors.textLight),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Ukończyłeś pomyślnie 100 problemów wspinaczkowych.',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textLight,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'Odblokowano: ${DateFormat.yMMMMd('pl').format(DateTime.now())}',
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        LucideIcons.trophy,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
