import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_media_resources.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';
import 'package:bouldee/app/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bouldee_onboarding.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            top: 16,
            left: 32,
            child: SafeArea(
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    AppMediaRes.appLogo,
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    'bouldee',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your wall, your rules',
                  style: context.textTheme.displayLarge?.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                Text(
                  'Your climbing journey starts here – plan, climb and crush your goals!',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Column(
                  children: [
                    AppButton(
                      text: 'Get Started',
                      onPressed: () {
                        context.router.push(const SignUpRoute());
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.router.push(const SignInRoute());
                          },
                          child: Text(
                            'Sign In',
                            style: context.textTheme.labelMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
