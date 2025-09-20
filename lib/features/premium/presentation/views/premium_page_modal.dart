import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_sizes.dart';
import 'package:bouldee/app/constants/enums.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/widgets/app_button.dart';
import 'package:bouldee/app/widgets/app_premium_logo.dart';
import 'package:bouldee/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:bouldee/features/premium/presentation/widgets/premium_features_list.dart';
import 'package:bouldee/features/premium/presentation/widgets/subscription_type_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PremiumModalPage extends StatelessWidget {
  const PremiumModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bouldee_onboarding.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.65,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(
                  LucideIcons.x,
                  color: AppColors.textLight,
                  size: 28,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: BlocBuilder<PremiumBloc, PremiumState>(
                builder: (context, state) {
                  final premiumState = state as PremiumLoaded;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.defaultHorizontalPadding,
                    ),
                    child: Column(
                      children: [
                        const AppPremiumLogo(size: 64),
                        const SizedBox(height: 96),
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: 'Wspinaj się mądrzej, ',
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: 'nie ciężej',
                                style:
                                    context.textTheme.headlineMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: '!',
                                style:
                                    context.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text:
                                'Uzyskaj dostęp do wszystkich funkcji z kontem ',
                            style: context.textTheme.labelMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'summit',
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: '.',
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const PremiumFeaturesList(),
                        const SizedBox(height: 16),
                        Text(
                          'Zacznij swój darmowy okres próbny już dziś!',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          spacing: 24,
                          children: [
                            SubscriptionTypeTile(
                              type: 'Miesięczna',
                              price: '4,99 zł / mies.',
                              isSelected:
                                  premiumState.selectedSubscriptionType ==
                                      SubscriptionType.monthly,
                              description: 'Płatność co miesiąc',
                              onTap: () {
                                context.read<PremiumBloc>().add(
                                      const PremiumSubscriptionTypeChanged(
                                        SubscriptionType.monthly,
                                      ),
                                    );
                              },
                            ),
                            SubscriptionTypeTile(
                              type: 'Roczna',
                              price: '47,99 zł / rok',
                              discounted: true,
                              freeTrialPossible: true,
                              isSelected:
                                  premiumState.selectedSubscriptionType ==
                                      SubscriptionType.yearly,
                              onTap: () {
                                context.read<PremiumBloc>().add(
                                      const PremiumSubscriptionTypeChanged(
                                        SubscriptionType.yearly,
                                      ),
                                    );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          text: 'Rozpocznij Premium',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
