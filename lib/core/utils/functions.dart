import 'dart:io';

import 'package:correct_hustle/features/widgets/error_alert_widget.dart';
import 'package:correct_hustle/features/widgets/success_alert_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

void showSuccessAlert(BuildContext context, {required String message, required Function onOkay}) {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      content: SuccessAlertWidget(
        message: message,
        onOkay: onOkay,
      ),
      contentPadding: const EdgeInsets.all(0),
      // insetPadding: EdgeInsets.all(0),
    );
  }, barrierDismissible: false, );
}

void showErrorAlert(BuildContext context, {required String message}) {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      content: ErrorAlertWidget(
        message: message,
        // onOkay: onOkay,
      ),
      contentPadding: const EdgeInsets.all(0),
      // insetPadding: EdgeInsets.all(0),
    );
  }, barrierDismissible: false, );
}

Future<String?> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if(Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // unique ID on Android
  }
}