import 'package:auto_route/auto_route.dart';
import 'package:bouldee/app/dependency_injection/dependency_injection.dart';
import 'package:bouldee/app/routing/app_router.gr.dart';
import 'package:bouldee/features/auth/presentation/bloc/auth_bloc.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard() {
    try {
      getIt<AuthBloc>().stream.listen((state) {
        _isAuthenticated = state is AuthUserAuthenticated;
      });

      _isAuthenticated = getIt<AuthBloc>().state is AuthUserAuthenticated;
    } catch (e) {
      print('Error in AuthGuard constructor: $e');
      _isAuthenticated = false;
    }
  }

  bool _isAuthenticated = false;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_isAuthenticated) {
      resolver.next();
    } else {
      resolver.redirect(const OnboardingRoute());
    }
  }
}
