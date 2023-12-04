import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class CacheHelper {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // UserId
  static Future<bool> saveUserId(String userId) async {
    return await prefs.setString(prefsUserId, userId);
  }

  static Future<bool> removeUserId() async {
    return await prefs.remove(prefsUserId);
  }

  static String getUserId() {
    final result = prefs.getString(prefsUserId) ?? '';
    return result;
  }

  // Locale
  static Future<bool> saveLanguageCode(String languageCode) async {
    return await prefs.setString(prefsLanguageCode, languageCode);
  }

  static String getLanguageCode() {
    final result = prefs.getString(prefsLanguageCode) ?? '';
    return result;
  }
}
