import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNotificationService {

  FlutterLocalNotificationsPlugin localNote;

  LocalNotificationService(this.localNote) {
    initialize();
  }


  void initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await localNote.initialize(initializationSettings);
    _requestPermissions();
  }


  _selectNotification(String? payload) async {
    debugPrint('notification payload: ${payload!.trim()}');
    final message = json.decode(payload.trim());
    if (message != {}) {
      
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await localNote.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      // await localNote.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      localNote.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
    }
  }
}

void onDidReceiveLocalNotification(_1, _2, _3, _4) {}