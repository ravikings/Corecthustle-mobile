
import 'package:correct_hustle/core/routes/routes.dart';
import 'package:correct_hustle/core/services/local_storage/hive.localstorage.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUpLocator() {
  getIt.registerSingleton<AppRouter>(AppRouter());
  getIt.registerSingleton<ILocalStorageService>(HiveLocalStorageService());

  getIt.registerSingleton<Dio>(Dio(BaseOptions(
    baseUrl: "https://pallytopit.com.ng/api/",
    contentType: 'application/json',
    responseType: ResponseType.json,
    headers: {
      'accept': 'application/json'
    }
  )));
  getIt<Dio>().interceptors.add(PrettyDioLogger());
}