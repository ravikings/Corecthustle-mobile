
import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void navigate() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM TOKEN ::: $fcmToken');
    final firstTime = await getIt<ILocalStorageService>().getItem(appDataBox, firstTimeKey, defaultValue: true);
    if (firstTime) {
      getIt<AppRouter>().replace(const RegisterRoute());
    } else {
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      if (token != null) {
        getIt<AppRouter>().replace(AppRoute(url: "http://pallytopit.com.ng?token=$token&hst_footer=false"));
      } else {
        getIt<AppRouter>().replace(const LoginRoute());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    navigate();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          382.toColumSpace(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70.w),
            child: Assets.svgs.logo.svg(),
          ),
          250.toColumSpace(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Assets.svgs.loader.svg(
              height: 60.h, width: 60.w
            ).animate(
              autoPlay: true,
              onComplete: (controller) => controller.repeat(),
            ).rotate(
              duration: 2.seconds
            ),
          ),
          54.toColumSpace()
        ],
      ),
    );
  }
}