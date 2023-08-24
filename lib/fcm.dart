import 'dart:convert';
import 'dart:io';

import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/services/local_storage/hive.localstorage.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'core/constants/constants.dart';
import 'local_notification.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  PushNotificationService(this._fcm);

  Future initialise(BuildContext context) async {
    LocalNotificationService(flutterLocalNotificationsPlugin);
    if (Platform.isIOS) {
      _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String? token = await _fcm.getToken();
    // print("FCMToken ::: $token");
    /// save token to local storage
    await getIt<ILocalStorageService>().setItem(appDataBox, pushNotificationKey, token);

    _fcm.onTokenRefresh.listen((fcmToken) async {
      /// saved token to local storage
      await getIt<ILocalStorageService>().setItem(appDataBox, pushNotificationKey, token).then((value) {
        // print("FirebaseMessaging token: $token ::: SavedOnRefresh");
      });
    }).onError((err) {
      // Error getting token.
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      // print("note ::: something for here");


      if (message.data != {}) {
        final notificationData = message.data;
        // if (notificationData.keys.contains('url')) {
        //   ToastAlert.showInfoAlert(message.notification!.body ?? "You need to see this.", onClick: () {
        //     getIt<RioAppRouter>().pushNamed(message.data['url']);
        //   }, time: 20);
        // }
        // if (notificationData.keys.contains('refreshBalance')) {
        //   context.read<UserAccountsProvider>().initialize();
        //   context.read<UserTransactionProvider>().initialize();
        //   // context.read<Balance>().initialize();
        // }
      }

      if (message.notification != null) {
        // print('Message also contained a notification: ${message.notification}');
        AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('correct_hustle', 'Correct Hustle',
          channelDescription: 'Correct Hustle Notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          playSound: true,
          color: Colors.red
        );
        var iosDetails = const DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
          badgeNumber: 10,
        );
        NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iosDetails
        );

        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
          platformChannelSpecifics,
          payload: json.encode(message.data),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("MessagOpenedApp");
      if (message.data != {}) {
        final notificationData = message.data;
        // if (notificationData.keys.contains('url')) {
        //   ToastAlert.showInfoAlert(message.notification!.body ?? "You need to see this.", onClick: () {
        //     getIt<RioAppRouter>().pushNamed(message.data['url']);
        //   }, time: 20);
        // }
        // if (notificationData.keys.contains('refreshBalance')) {
        //   context.read<UserAccountsProvider>().initialize();
        //   context.read<UserTransactionProvider>().initialize();
        // }
      }
    });

  }
}