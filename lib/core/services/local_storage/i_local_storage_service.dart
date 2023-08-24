abstract class ILocalStorageService {
  Future<void> init();
  Future<bool> setItem(storage, key, value);
  Future<dynamic> getItem(storage, key, {dynamic defaultValue});
  Future<bool> removeItem(storage, key);
}