import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  static final LocalStorage _instance = LocalStorage._();
  LocalStorage._();
  factory LocalStorage() => _instance;

  static LocalStorage instance = LocalStorage();

  Future<SharedPreferences> get _local async => await SharedPreferences.getInstance();

  Future<void> onSave(String key, String value) async {
    await (await _local).setString(key, value);
  }

  Future<String?> onGet(String key) async {
    return (await _local).getString(key);
  }
}