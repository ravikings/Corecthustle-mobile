import 'dart:io';

import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/fcm.dart';
import 'package:correct_hustle/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:permission_handler/permission_handler.dart';



@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await getIt<ILocalStorageService>().init();

  Permission.camera.request();
  Permission.microphone.request();
  Permission.storage.request();

  
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  if (Platform.isIOS) {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');

  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //   }
  // });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final _fcm = FirebaseMessaging.instance;

  final _approuter = getIt<AppRouter>();

  final botToastBuilder = BotToastInit();

  void _listenToDeepLink() async {
    FirebaseDynamicLinks.instance.onLink.listen((linkData) => _handleDeepLink(linkData)).onError((error) {
      print("DeepLinkError:: $error");
    });
  }

  void _checkForIntialDeepLink() async {
    final PendingDynamicLinkData? dynamicLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (dynamicLink != null) {
      _handleDeepLink(dynamicLink);
    }
  }

  void _handleDeepLink(PendingDynamicLinkData link) {
    print("DynamicLinkData ::: ${link.toString()}");
    final urlParams = link.link;
    getIt<AppRouter>().replaceAll([AppRoute(url: urlParams.toString())]);
  }

  @override
  void initState() {
    super.initState();
    PushNotificationService(_fcm).initialise(context);
    _checkForIntialDeepLink();
    _listenToDeepLink();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Correct Hustle',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            textTheme: GoogleFonts.heeboTextTheme()
          ),
          routeInformationParser: _approuter.defaultRouteParser(),
          routeInformationProvider: _approuter.routeInfoProvider(),
          routerDelegate: _approuter.delegate(),
          builder: (context, child) {
            return botToastBuilder(context, child);
          },
        );
      },
    );
  }
}

