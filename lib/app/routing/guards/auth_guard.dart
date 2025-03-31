import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';
import 'package:bouldee/features/auth/presentation/bloc/auth_bloc.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authBloc = getIt<AuthBloc>();

    if (authBloc.state is AuthUserAuthenticated) {
      resolver.next();
    } else if (authBloc.state is AuthInitial) {
      final currentUser = authBloc.getCurrentUser();
      if (currentUser != null) {
        resolver.next();
      } else {
        resolver.redirect(const OnboardingRoute());
      }
    } else {
      resolver.redirect(const OnboardingRoute());
    }
  }
}
