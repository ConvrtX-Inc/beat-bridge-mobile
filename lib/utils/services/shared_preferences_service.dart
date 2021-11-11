/*
  In this file, we write all the code needed to store and get data from the local storage using the plugin shared_preferences.
  In this file, there will be getters and setters for each and every data to be stored in the local storage.
 */

// ignore_for_file: avoid_classes_with_only_static_members
// import 'package:shared_preferences/shared_preferences.dart';
//
// /// Shared preferences repository
// class SharedPreferencesRepository {
//   static SharedPreferences? _prefs;
//
//   static init() async {
//     _prefs = await SharedPreferences.getInstance();
//   }
//
//   static putInteger(String key, int value) {
//     if (_prefs != null) _prefs!.setInt(key, value);
//   }
//
//   static int getInteger(String key) {
//     return _prefs == null ? 0 : _prefs!.getInt(key) ?? 0;
//   }
//
//   static putString(String key, String value) {
//     if (_prefs != null) _prefs!.setString(key, value);
//   }
//
//   static String getString(String key) {
//     return _prefs == null ? 'DEFAULT_VALUE' : _prefs!.getString(key) ?? "";
//   }
//
//   static putBool(String key, bool value) {
//     if (_prefs != null) _prefs!.setBool(key, value);
//   }
//
//   static bool getBool(String key) {
//     return _prefs == null ? false : _prefs!.getBool(key) ?? false;
//   }
// }
