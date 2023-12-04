import 'package:flutter/material.dart';

final Map<String, String> jsonHeader = {'Content-Type': 'application/json'};

const int userType = 0;

// dayOfWeek的列表
final List<int> dayNumbers = List.generate(7, (index) => index + 1);

// SharedPreferences
const String prefsUserId = 'userId';
const String prefsLanguageCode = 'languageCode';

// Locale
const List<Map<String, dynamic>> localeMapList = [
  {
    'languageCode': 'en',
    'title': 'English',
    'locale': Locale('en', 'US'),
  },
  {
    'languageCode': 'zh',
    'title': '繁體中文',
    'locale': Locale('zh', 'TW'),
  },
];

final List<Locale> supportedLocale =
    localeMapList.map<Locale>((item) => item['locale']).toList();
