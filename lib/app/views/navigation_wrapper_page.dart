import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/constants/app_colors.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class NavigationWrapperPage extends StatelessWidget {
  const NavigationWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        HomeRoute(),
        HomeRoute(),
        HomeRoute(),
        HomeRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = context.tabsRouter;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: child,
          bottomNavigationBar: AppNavigationBottomBar(
            tabsRouter: tabsRouter,
          ),
        );
      },
    );
  }
}

class AppNavigationBottomBar extends StatelessWidget {
  const AppNavigationBottomBar({required this.tabsRouter, super.key});

  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .4),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomAppBar(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: AppColors.background,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavigationBarItem(
                  iconData: LucideIcons.house,
                  onPressed: () => tabsRouter.setActiveIndex(0),
                ),
                NavigationBarItem(
                  iconData: LucideIcons.map,
                  onPressed: () => tabsRouter.setActiveIndex(1),
                ),
                const SizedBox(width: 64),
                NavigationBarItem(
                  iconData: LucideIcons.chartNoAxesCombined,
                  onPressed: () => tabsRouter.setActiveIndex(3),
                ),
                NavigationBarItem(
                  iconData: LucideIcons.circleUser,
                  onPressed: () => tabsRouter.setActiveIndex(4),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 45,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primary,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => tabsRouter.setActiveIndex(2),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(
                    LucideIcons.route,
                    size: 36,
                    color: AppColors.tileColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NavigationBarItem extends StatelessWidget {
  const NavigationBarItem({
    required this.iconData,
    required this.onPressed,
    super.key,
  });

  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 64,
          maxWidth: 64,
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              iconData,
            ),
          ),
        ),
      ),
    );
  }
}
