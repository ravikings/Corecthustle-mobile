// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i14;
import 'package:correct_hustle/features/app/presentation/screen/app_base_screen.dart'
    as _i1;
import 'package:correct_hustle/features/app/presentation/screen/app_screen.dart'
    as _i2;
import 'package:correct_hustle/features/chat/chat_base_screen.dart' as _i3;
import 'package:correct_hustle/features/chat/chat_list_screen.dart' as _i4;
import 'package:correct_hustle/features/chat/chat_message/chat_mesage_base_screen.dart'
    as _i5;
import 'package:correct_hustle/features/chat/chat_message/chat_messages_screen.dart'
    as _i6;
import 'package:correct_hustle/features/chat/chat_message/select_offer_screen.dart'
    as _i7;
import 'package:correct_hustle/features/chat/chat_message/select_quotes_screen.dart'
    as _i8;
import 'package:correct_hustle/features/chat/chat_message/view_quote_screen.dart'
    as _i9;
import 'package:correct_hustle/features/chat/data/model/chat_quote_mode.dart'
    as _i16;
import 'package:correct_hustle/features/login/presentation/screens/login_screen.dart'
    as _i10;
import 'package:correct_hustle/features/register/presentation/screens/register_screen.dart'
    as _i11;
import 'package:correct_hustle/features/splash_screen/presentation/screens/splash_screen.dart'
    as _i12;
import 'package:correct_hustle/features/verify_account_screen/verify_account_screen.dart'
    as _i13;
import 'package:flutter/material.dart' as _i15;

abstract class $AppRouter extends _i14.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    AppBaseRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppBaseScreen(),
      );
    },
    AppRoute.name: (routeData) {
      final args = routeData.argsAs<AppRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.AppScreen(
          key: args.key,
          url: args.url,
          canExitFreely: args.canExitFreely,
        ),
      );
    },
    ChatBaseRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ChatBaseScreen(),
      );
    },
    ChatListRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ChatListScreen(),
      );
    },
    ChatMessageBaseRoute.name: (routeData) {
      final args = routeData.argsAs<ChatMessageBaseRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ChatMessageBaseScreen(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    ChatMessagesRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ChatMessagesScreen(),
      );
    },
    SelectOfferRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SelectOfferScreen(),
      );
    },
    SelectQuotesRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.SelectQuotesScreen(),
      );
    },
    ViewQuoteRoute.name: (routeData) {
      final args = routeData.argsAs<ViewQuoteRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.ViewQuoteScreen(
          key: args.key,
          quote: args.quote,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.LoginScreen(),
      );
    },
    RegisterRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.RegisterScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SplashScreen(),
      );
    },
    VerifyAccountRoute.name: (routeData) {
      final args = routeData.argsAs<VerifyAccountRouteArgs>();
      return _i14.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.VerifyAccountScreen(
          key: args.key,
          email: args.email,
          token: args.token,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AppBaseScreen]
class AppBaseRoute extends _i14.PageRouteInfo<void> {
  const AppBaseRoute({List<_i14.PageRouteInfo>? children})
      : super(
          AppBaseRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppBaseRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AppScreen]
class AppRoute extends _i14.PageRouteInfo<AppRouteArgs> {
  AppRoute({
    _i15.Key? key,
    required String url,
    bool canExitFreely = false,
    List<_i14.PageRouteInfo>? children,
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

  static const _i14.PageInfo<AppRouteArgs> page =
      _i14.PageInfo<AppRouteArgs>(name);
}

class AppRouteArgs {
  const AppRouteArgs({
    this.key,
    required this.url,
    this.canExitFreely = false,
  });

  final _i15.Key? key;

  final String url;

  final bool canExitFreely;

  @override
  String toString() {
    return 'AppRouteArgs{key: $key, url: $url, canExitFreely: $canExitFreely}';
  }
}

/// generated route for
/// [_i3.ChatBaseScreen]
class ChatBaseRoute extends _i14.PageRouteInfo<void> {
  const ChatBaseRoute({List<_i14.PageRouteInfo>? children})
      : super(
          ChatBaseRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatBaseRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ChatListScreen]
class ChatListRoute extends _i14.PageRouteInfo<void> {
  const ChatListRoute({List<_i14.PageRouteInfo>? children})
      : super(
          ChatListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatListRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ChatMessageBaseScreen]
class ChatMessageBaseRoute
    extends _i14.PageRouteInfo<ChatMessageBaseRouteArgs> {
  ChatMessageBaseRoute({
    _i15.Key? key,
    required String userId,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          ChatMessageBaseRoute.name,
          args: ChatMessageBaseRouteArgs(
            key: key,
            userId: userId,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatMessageBaseRoute';

  static const _i14.PageInfo<ChatMessageBaseRouteArgs> page =
      _i14.PageInfo<ChatMessageBaseRouteArgs>(name);
}

class ChatMessageBaseRouteArgs {
  const ChatMessageBaseRouteArgs({
    this.key,
    required this.userId,
  });

  final _i15.Key? key;

  final String userId;

  @override
  String toString() {
    return 'ChatMessageBaseRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [_i6.ChatMessagesScreen]
class ChatMessagesRoute extends _i14.PageRouteInfo<void> {
  const ChatMessagesRoute({List<_i14.PageRouteInfo>? children})
      : super(
          ChatMessagesRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatMessagesRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SelectOfferScreen]
class SelectOfferRoute extends _i14.PageRouteInfo<void> {
  const SelectOfferRoute({List<_i14.PageRouteInfo>? children})
      : super(
          SelectOfferRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectOfferRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i8.SelectQuotesScreen]
class SelectQuotesRoute extends _i14.PageRouteInfo<void> {
  const SelectQuotesRoute({List<_i14.PageRouteInfo>? children})
      : super(
          SelectQuotesRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectQuotesRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ViewQuoteScreen]
class ViewQuoteRoute extends _i14.PageRouteInfo<ViewQuoteRouteArgs> {
  ViewQuoteRoute({
    _i15.Key? key,
    required _i16.ChatQuoteModel quote,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          ViewQuoteRoute.name,
          args: ViewQuoteRouteArgs(
            key: key,
            quote: quote,
          ),
          initialChildren: children,
        );

  static const String name = 'ViewQuoteRoute';

  static const _i14.PageInfo<ViewQuoteRouteArgs> page =
      _i14.PageInfo<ViewQuoteRouteArgs>(name);
}

class ViewQuoteRouteArgs {
  const ViewQuoteRouteArgs({
    this.key,
    required this.quote,
  });

  final _i15.Key? key;

  final _i16.ChatQuoteModel quote;

  @override
  String toString() {
    return 'ViewQuoteRouteArgs{key: $key, quote: $quote}';
  }
}

/// generated route for
/// [_i10.LoginScreen]
class LoginRoute extends _i14.PageRouteInfo<void> {
  const LoginRoute({List<_i14.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i11.RegisterScreen]
class RegisterRoute extends _i14.PageRouteInfo<void> {
  const RegisterRoute({List<_i14.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SplashScreen]
class SplashRoute extends _i14.PageRouteInfo<void> {
  const SplashRoute({List<_i14.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i14.PageInfo<void> page = _i14.PageInfo<void>(name);
}

/// generated route for
/// [_i13.VerifyAccountScreen]
class VerifyAccountRoute extends _i14.PageRouteInfo<VerifyAccountRouteArgs> {
  VerifyAccountRoute({
    _i15.Key? key,
    required String email,
    required String token,
    List<_i14.PageRouteInfo>? children,
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

  static const _i14.PageInfo<VerifyAccountRouteArgs> page =
      _i14.PageInfo<VerifyAccountRouteArgs>(name);
}

class VerifyAccountRouteArgs {
  const VerifyAccountRouteArgs({
    this.key,
    required this.email,
    required this.token,
  });

  final _i15.Key? key;

  final String email;

  final String token;

  @override
  String toString() {
    return 'VerifyAccountRouteArgs{key: $key, email: $email, token: $token}';
  }
}
