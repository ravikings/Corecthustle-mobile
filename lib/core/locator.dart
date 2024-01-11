
import 'package:correct_hustle/core/routes/routes.dart';
import 'package:correct_hustle/core/services/local_storage/hive.localstorage.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:get_it/get_it.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

final getIt = GetIt.instance;

void setUpLocator() {
  getIt.registerSingleton<AppRouter>(AppRouter());
  getIt.registerSingleton<ILocalStorageService>(HiveLocalStorageService());

  getIt.registerFactory<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: "https://pallytopit.com.ng/api/",
      contentType: 'application/json',
      responseType: ResponseType.json,
      headers: {
        'accept': 'application/json'
      }
    ));
    dio.interceptors.add(PrettyDioLogger());
    return dio;
  });

  getIt.registerSingleton<PusherChannelsFlutter>(PusherChannelsFlutter.getInstance());
}