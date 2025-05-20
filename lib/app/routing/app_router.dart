import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';
import 'package:bouldee/app/routing/guards/auth_guard.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: NavigationWrapperRoute.page,
          initial: true,
          guards: [AuthGuard()],
          children: [
            AutoRoute(page: HomeRoute.page),
            AutoRoute(page: ClubMapRoute.page),
            AutoRoute(page: ProfileRoute.page),
          ],
        ),
        AutoRoute(page: OnboardingRoute.page),
        AutoRoute(page: SignInRoute.page),
        AutoRoute(page: SignUpRoute.page),
        AutoRoute(page: CurrentTrainingSessionRoute.page),
        AutoRoute(page: BoulderDetailsRoute.page),
      ];
}
