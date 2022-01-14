import 'package:shared_preferences/shared_preferences.dart';

/// Shared preferences repository
class SharedPreferencesRepository {
  ///Constructor
  SharedPreferencesRepository();
  static SharedPreferences? _prefs;

  ///Initialize shared preferences
 static Future<void> init() async {
     _prefs = await SharedPreferences.getInstance();
  }

  ///Store integer
  static void putInteger(String key, int value) {
    if (_prefs != null) {
      _prefs!.setInt(key, value);
    }
  }

  ///Get Stored Integer data
  static int getInteger(String key) {
    return _prefs == null ? 0 : _prefs!.getInt(key) ?? 0;
  }

  ///Store String
  static void putString(String key, String value) {
     if (_prefs != null) {
      _prefs!.setString(key, value);
    }
  }

  ///Get Stored String data
  static String getString(String key) {
    return _prefs == null ? 'DEFAULT_VALUE' : _prefs!.getString(key) ?? "";
  }

  ///Store boolean data
  static void putBool({String? key, bool? value}) {
    if (_prefs != null) {
      _prefs!.setBool(key!, value!);
    }
  }

  ///Get Stored Boolean data
  static  bool getBool(String key) {
    if (_prefs == null) {
      return false;
    } else {
      return _prefs!.getBool(key) ?? false;
    }
  }

  ///Clear data stored
  static Future<void> clear() async {
    if (_prefs != null) {
      await _prefs!.clear();
    }
  }
}
