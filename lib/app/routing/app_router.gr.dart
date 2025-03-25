// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:bouldee/app/views/navigation_wrapper_page.dart' as _i3;
import 'package:bouldee/features/auth/presentation/views/sign_in_page.dart'
    as _i5;
import 'package:bouldee/features/auth/presentation/views/sign_up_page.dart'
    as _i6;
import 'package:bouldee/features/club_interactive_map/presentation/club_interactive_map_page.dart'
    as _i1;
import 'package:bouldee/features/home/presentation/views/home_page.dart' as _i2;
import 'package:bouldee/features/onboarding/views/onboarding_page.dart' as _i4;

/// generated route for
/// [_i1.ClubInteractiveMapPage]
class ClubInteractiveMapRoute extends _i7.PageRouteInfo<void> {
  const ClubInteractiveMapRoute({List<_i7.PageRouteInfo>? children})
    : super(ClubInteractiveMapRoute.name, initialChildren: children);

  static const String name = 'ClubInteractiveMapRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.ClubInteractiveMapPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.NavigationWrapperPage]
class NavigationWrapperRoute extends _i7.PageRouteInfo<void> {
  const NavigationWrapperRoute({List<_i7.PageRouteInfo>? children})
    : super(NavigationWrapperRoute.name, initialChildren: children);

  static const String name = 'NavigationWrapperRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.NavigationWrapperPage();
    },
  );
}

/// generated route for
/// [_i4.OnboardingPage]
class OnboardingRoute extends _i7.PageRouteInfo<void> {
  const OnboardingRoute({List<_i7.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i5.SignInPage]
class SignInRoute extends _i7.PageRouteInfo<void> {
  const SignInRoute({List<_i7.PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.SignInPage();
    },
  );
}

/// generated route for
/// [_i6.SignUpPage]
class SignUpRoute extends _i7.PageRouteInfo<void> {
  const SignUpRoute({List<_i7.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.SignUpPage();
    },
  );
}
