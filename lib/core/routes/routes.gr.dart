// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:correct_hustle/features/app/presentation/screen/app_screen.dart'
    as _i1;
import 'package:correct_hustle/features/login/presentation/screens/login_screen.dart'
    as _i2;
import 'package:correct_hustle/features/register/presentation/screens/register_screen.dart'
    as _i3;
import 'package:correct_hustle/features/splash_screen/presentation/screens/splash_screen.dart'
    as _i4;
import 'package:correct_hustle/features/verify_account_screen/verify_account_screen.dart'
    as _i5;
import 'package:flutter/material.dart' as _i7;

abstract class $AppRouter extends _i6.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    AppRoute.name: (routeData) {
      final args = routeData.argsAs<AppRouteArgs>();
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AppScreen(
          key: args.key,
          url: args.url,
          canExitFreely: args.canExitFreely,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.LoginScreen(),
      );
    },
    RegisterRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.RegisterScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.SplashScreen(),
      );
    },
    VerifyAccountRoute.name: (routeData) {
      final args = routeData.argsAs<VerifyAccountRouteArgs>();
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.VerifyAccountScreen(
          key: args.key,
          email: args.email,
          token: args.token,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AppScreen]
class AppRoute extends _i6.PageRouteInfo<AppRouteArgs> {
  AppRoute({
    _i7.Key? key,
    required String url,
    bool canExitFreely = false,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          AppRoute.name,
          args: AppRouteArgs(
            key: key,
            url: url,
            canExitFreely: canExitFreely,
          ),
          initialChildren: children,
        );

  static const String name = 'AppRoute';

  static const _i6.PageInfo<AppRouteArgs> page =
      _i6.PageInfo<AppRouteArgs>(name);
}

class AppRouteArgs {
  const AppRouteArgs({
    this.key,
    required this.url,
    this.canExitFreely = false,
  });

  final _i7.Key? key;

  final String url;

  final bool canExitFreely;

  @override
  String toString() {
    return 'AppRouteArgs{key: $key, url: $url, canExitFreely: $canExitFreely}';
  }
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i3.RegisterScreen]
class RegisterRoute extends _i6.PageRouteInfo<void> {
  const RegisterRoute({List<_i6.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i4.SplashScreen]
class SplashRoute extends _i6.PageRouteInfo<void> {
  const SplashRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i5.VerifyAccountScreen]
class VerifyAccountRoute extends _i6.PageRouteInfo<VerifyAccountRouteArgs> {
  VerifyAccountRoute({
    _i7.Key? key,
    required String email,
    required String token,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          VerifyAccountRoute.name,
          args: VerifyAccountRouteArgs(
            key: key,
            email: email,
            token: token,
          ),
          initialChildren: children,
        );

  static const String name = 'VerifyAccountRoute';

  static const _i6.PageInfo<VerifyAccountRouteArgs> page =
      _i6.PageInfo<VerifyAccountRouteArgs>(name);
}

class VerifyAccountRouteArgs {
  const VerifyAccountRouteArgs({
    this.key,
    required this.email,
    required this.token,
  });

  final _i7.Key? key;

  final String email;

  final String token;

  @override
  String toString() {
    return 'VerifyAccountRouteArgs{key: $key, email: $email, token: $token}';
  }
}
