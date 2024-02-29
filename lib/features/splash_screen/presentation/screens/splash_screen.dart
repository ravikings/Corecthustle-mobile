
import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/core/utils/functions.dart';
import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      navigate();
    });
  }
  void navigate() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print('FCM TOKEN ::: $fcmToken');
      final firstTime = await getIt<ILocalStorageService>().getItem(appDataBox, firstTimeKey, defaultValue: true);
      if (firstTime) {
        await getIt<ILocalStorageService>().setItem(appDataBox, firstTimeKey, false);
        getIt<AppRouter>().replace(const RegisterRoute());
      } else {
        final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
        if (token != null) {
          getIt<AppRouter>().replace(AppBaseRoute(
            children: [
              AppRoute(url: "$appUrl?token=$token&hst_footer=false")
            ]
          ));
        } else {
          getIt<AppRouter>().replace(const LoginRoute());
        }
      }
    } catch (error) {
      getIt<AppRouter>().replace(const RegisterRoute());
    }
  }

  void _audioPermission() async {
    // await [Permission.storage, Permission.microphone].request();
  }

  @override
  Widget build(BuildContext context) {
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