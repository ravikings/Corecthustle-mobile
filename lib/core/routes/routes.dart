

import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: "Screen,Route")
class AppRouter extends $AppRouter {
  @override
  // TODO: implement routes
  List<AutoRoute> get routes => [
    
    CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: SplashRoute.page, path: "/"),
    CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: RegisterRoute.page, path: "/register"),
    CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: LoginRoute.page, path: "/login"),
    CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: VerifyAccountRoute.page, path: "/verify"),

    CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: AppBaseRoute.page, path: "/app", children: [
      CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: AppRoute.page, path: "", initial: true),
      
      CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: ChatBaseRoute.page, path: "chat", children: [
        CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: ChatListRoute.page, path: "", initial: true),
        CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: ChatMessageBaseRoute.page, path: "", children: [
          CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: ChatMessagesRoute.page, path: "", initial: true),

          CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: SelectOfferRoute.page, path: "select_offer"),
          CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: SelectQuotesRoute.page, path: "select_quote"),
        ]),
        CustomRoute(transitionsBuilder: TransitionsBuilders.slideRightWithFade, page: ViewQuoteRoute.page, path: "view_quote"),
        
      ]),
    ]),

  ];

}