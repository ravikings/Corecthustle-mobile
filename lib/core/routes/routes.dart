

import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: "Screen,Route")
class AppRouter extends $AppRouter {
  @override
  // TODO: implement routes
  List<AutoRoute> get routes => [
    
    CustomRoute(page: SplashRoute.page, path: "/"),
    CustomRoute(page: RegisterRoute.page, path: "/register"),
    CustomRoute(page: LoginRoute.page, path: "/login"),
    CustomRoute(page: VerifyAccountRoute.page, path: "/verify"),
    CustomRoute(page: AppRoute.page, path: "/app"),

  ];

}