// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:bouldee/app/views/navigation_wrapper_page.dart' as _i4;
import 'package:bouldee/features/auth/presentation/views/sign_in_page.dart'
    as _i6;
import 'package:bouldee/features/auth/presentation/views/sign_up_page.dart'
    as _i7;
import 'package:bouldee/features/club_map/presentation/club_map_page.dart'
    as _i1;
import 'package:bouldee/features/home/presentation/views/home_page.dart' as _i3;
import 'package:bouldee/features/onboarding/views/onboarding_page.dart' as _i5;
import 'package:bouldee/features/training_session/presentation/idea.dart'
    as _i2;
import 'package:flutter/material.dart' as _i9;

/// generated route for
/// [_i1.ClubMapPage]
class ClubMapRoute extends _i8.PageRouteInfo<ClubMapRouteArgs> {
  ClubMapRoute({
    required String clubId,
    _i9.Key? key,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         ClubMapRoute.name,
         args: ClubMapRouteArgs(clubId: clubId, key: key),
         rawPathParams: {'clubId': clubId},
         initialChildren: children,
       );

  static const String name = 'ClubMapRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ClubMapRouteArgs>(
        orElse: () => ClubMapRouteArgs(clubId: pathParams.getString('clubId')),
      );
      return _i1.ClubMapPage(clubId: args.clubId, key: args.key);
    },
  );
}

class ClubMapRouteArgs {
  const ClubMapRouteArgs({required this.clubId, this.key});

  final String clubId;

  final _i9.Key? key;

  @override
  String toString() {
    return 'ClubMapRouteArgs{clubId: $clubId, key: $key}';
  }
}

/// generated route for
/// [_i2.CurrentTrainingSessionPage]
class CurrentTrainingSessionRoute extends _i8.PageRouteInfo<void> {
  const CurrentTrainingSessionRoute({List<_i8.PageRouteInfo>? children})
    : super(CurrentTrainingSessionRoute.name, initialChildren: children);

  static const String name = 'CurrentTrainingSessionRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.CurrentTrainingSessionPage();
    },
  );
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute({List<_i8.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomePage();
    },
  );
}

/// generated route for
/// [_i4.NavigationWrapperPage]
class NavigationWrapperRoute extends _i8.PageRouteInfo<void> {
  const NavigationWrapperRoute({List<_i8.PageRouteInfo>? children})
    : super(NavigationWrapperRoute.name, initialChildren: children);

  static const String name = 'NavigationWrapperRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.NavigationWrapperPage();
    },
  );
}

/// generated route for
/// [_i5.OnboardingPage]
class OnboardingRoute extends _i8.PageRouteInfo<void> {
  const OnboardingRoute({List<_i8.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i6.SignInPage]
class SignInRoute extends _i8.PageRouteInfo<void> {
  const SignInRoute({List<_i8.PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.SignInPage();
    },
  );
}

/// generated route for
/// [_i7.SignUpPage]
class SignUpRoute extends _i8.PageRouteInfo<void> {
  const SignUpRoute({List<_i8.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.SignUpPage();
    },
  );
}
