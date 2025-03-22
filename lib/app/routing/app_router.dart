import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // AutoRoute(
        //   page: MainNavigationRoute.page,
        //   initial: true,
        //   guards: [AuthGuard()],
        //   children: [
        //     AutoRoute(page: HomeRoute.page),
        //     AutoRoute(page: ExploreRoute.page),
        //     AutoRoute(page: VoyRoute.page),
        //     AutoRoute(page: TripsRoute.page),
        //     AutoRoute(page: ProfileRoute.page),
        //   ],
        // ),
        AutoRoute(page: OnboardingRoute.page, initial: true),
      ];
}
