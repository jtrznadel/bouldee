import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_media_resources.dart';
import 'package:bouldee/app/constants/app_sizes.dart';
import 'package:bouldee/app/extensions/context_extensions.dart';
import 'package:bouldee/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bouldee/features/home/presentation/widgets/home_last_session.dart';
import 'package:bouldee/features/home/presentation/widgets/home_mini_stats.dart';
import 'package:bouldee/features/premium/presentation/views/get_premium_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showPremiumModal(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PremiumModalPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          final scaleAnimation = Tween(begin: begin, end: end).animate(
            CurvedAnimation(parent: animation, curve: curve),
          );

          final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: animation, curve: curve),
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
        reverseTransitionDuration: const Duration(milliseconds: 200),
        opaque: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  context.read<AuthBloc>().add(AuthLogout());
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    image: DecorationImage(
                      image: AssetImage(AppMediaRes.deffaultAvatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    AppMediaRes.appLogo,
                    width: 30,
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'bouldee',
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: AppColors.textLight,
                          height: 1,
                        ),
                      ),
                      Text(
                        'summit',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _showPremiumModal(context),
                icon: const Icon(LucideIcons.bolt, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.defaultHorizontalPadding,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              HomeMiniStats(),
              HomeLastSession(),
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumModalPage extends StatelessWidget {
  const PremiumModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            LucideIcons.x,
            color: AppColors.textLight,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Premium',
          style: context.textTheme.labelLarge?.copyWith(
            color: AppColors.textLight,
          ),
        ),
        centerTitle: true,
      ),
      body: const GetPremiumPage(),
    );
  }
}
