import 'package:shared_preferences/shared_preferences.dart';

/// Local Storage Service using SharedPreferences
class StorageService {
  static SharedPreferences? _preferences;
  
  /// Initialize storage service
  static Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
  }
  
  /// Ensure preferences is initialized
  static Future<SharedPreferences> get _prefs async {
    if (_preferences == null) {
      await initialize();
    }
    return _preferences!;
  }
  
  /// Store string value
  static Future<bool> setString(String key, String value) async {
    final prefs = await _prefs;
    return await prefs.setString(key, value);
  }
  
  /// Get string value
  static Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }
  
  /// Store integer value
  static Future<bool> setInt(String key, int value) async {
    final prefs = await _prefs;
    return await prefs.setInt(key, value);
  }
  
  /// Get integer value
  static Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }
  
  /// Store boolean value
  static Future<bool> setBool(String key, bool value) async {
    final prefs = await _prefs;
    return await prefs.setBool(key, value);
  }
  
  /// Get boolean value
  static Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }
  
  /// Store double value
  static Future<bool> setDouble(String key, double value) async {
    final prefs = await _prefs;
    return await prefs.setDouble(key, value);
  }
  
  /// Get double value
  static Future<double?> getDouble(String key) async {
    final prefs = await _prefs;
    return prefs.getDouble(key);
  }
  
  /// Store list of strings
  static Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _prefs;
    return await prefs.setStringList(key, value);
  }
  
  /// Get list of strings
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await _prefs;
    return prefs.getStringList(key);
  }
  
  /// Remove value by key
  static Future<bool> remove(String key) async {
    final prefs = await _prefs;
    return await prefs.remove(key);
  }
  
  /// Check if key exists
  static Future<bool> containsKey(String key) async {
    final prefs = await _prefs;
    return prefs.containsKey(key);
  }
  
  /// Get all keys
  static Future<Set<String>> getKeys() async {
    final prefs = await _prefs;
    return prefs.getKeys();
  }
  
  /// Clear all stored data
  static Future<bool> clearAll() async {
    final prefs = await _prefs;
    return await prefs.clear();
  }
  
  /// Reload preferences from storage
  static Future<void> reload() async {
    final prefs = await _prefs;
    await prefs.reload();
  }
}