import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/constants/app_media_resources.dart';
import 'package:bouldee/app/constants/app_sizes.dart';
import 'package:bouldee/app/widgets/app_premium_logo.dart';
import 'package:bouldee/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bouldee/features/home/presentation/widgets/home_last_session.dart';
import 'package:bouldee/features/home/presentation/widgets/home_mini_stats.dart';
import 'package:bouldee/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:bouldee/features/premium/presentation/views/premium_page_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showPremiumModal(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => PremiumBloc(),
          child: const PremiumModalPage(),
        ),
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
              const AppPremiumLogo(),
              GestureDetector(
                onTap: () => _showPremiumModal(context),
                child: const Icon(
                  LucideIcons.circleFadingArrowUp,
                  color: AppColors.primary,
                ),
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
