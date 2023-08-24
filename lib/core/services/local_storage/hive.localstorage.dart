import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;

class HiveLocalStorageService implements ILocalStorageService {

  @override
  Future getItem(storage, key, {defaultValue}) async {
    await init();
    final box = await Hive.openBox(storage);
    return await box.get(key, defaultValue: defaultValue);
  }

  @override
  Future<void> init() async {
    final appDDir = await path.getApplicationDocumentsDirectory();
    Hive.init(appDDir.path);
    await Hive.openBox(appDataBox);
    await Hive.openBox(userDataBox);
  }

  @override
  Future<bool> removeItem(storage, key) async {
    await init();
    final box = await Hive.openBox(storage);
    await box.delete(key);
    return true;
  }

  @override
  Future<bool> setItem(storage, key, value) async {
    await init();
    final box = await Hive.openBox(storage);
    await box.put(key, value);
    return true;
  }
}