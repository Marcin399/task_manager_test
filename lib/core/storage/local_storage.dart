import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<String?> getString(String key);
  Future<bool> setString(String key, String value);
  Future<int?> getInt(String key);
  Future<bool> setInt(String key, int value);
  Future<bool?> getBool(String key);
  Future<bool> setBool(String key, bool value);
  Future<double?> getDouble(String key);
  Future<bool> setDouble(String key, double value);
  Future<List<String>?> getStringList(String key);
  Future<bool> setStringList(String key, List<String> value);
  Future<bool> remove(String key);
  Future<bool> clear();
  Future<bool> containsKey(String key);
}

class LocalStorageImpl implements LocalStorage {
  SharedPreferences? _prefs;
  
  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }
  
  @override
  Future<String?> getString(String key) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }
  
  @override
  Future<bool> setString(String key, String value) async {
    final prefs = await _preferences;
    return prefs.setString(key, value);
  }
  
  @override
  Future<int?> getInt(String key) async {
    final prefs = await _preferences;
    return prefs.getInt(key);
  }
  
  @override
  Future<bool> setInt(String key, int value) async {
    final prefs = await _preferences;
    return prefs.setInt(key, value);
  }
  
  @override
  Future<bool?> getBool(String key) async {
    final prefs = await _preferences;
    return prefs.getBool(key);
  }
  
  @override
  Future<bool> setBool(String key, bool value) async {
    final prefs = await _preferences;
    return prefs.setBool(key, value);
  }
  
  @override
  Future<double?> getDouble(String key) async {
    final prefs = await _preferences;
    return prefs.getDouble(key);
  }
  
  @override
  Future<bool> setDouble(String key, double value) async {
    final prefs = await _preferences;
    return prefs.setDouble(key, value);
  }
  
  @override
  Future<List<String>?> getStringList(String key) async {
    final prefs = await _preferences;
    return prefs.getStringList(key);
  }
  
  @override
  Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _preferences;
    return prefs.setStringList(key, value);
  }
  
  @override
  Future<bool> remove(String key) async {
    final prefs = await _preferences;
    return prefs.remove(key);
  }
  
  @override
  Future<bool> clear() async {
    final prefs = await _preferences;
    return prefs.clear();
  }
  
  @override
  Future<bool> containsKey(String key) async {
    final prefs = await _preferences;
    return prefs.containsKey(key);
  }
}
