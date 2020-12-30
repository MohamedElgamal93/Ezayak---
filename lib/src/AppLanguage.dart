import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ezayak/app_constants.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale(EN);

  Locale get appLocal => _appLocale ?? Locale(EN);

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString(LANGUAGE_CODE) == null) {
      _appLocale = Locale(EN);
      return Null;
    }
    _appLocale = Locale(prefs.getString(LANGUAGE_CODE));
    return Null;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == Locale(AR)) {
      _appLocale = Locale(AR);
      await prefs.setString(LANGUAGE_CODE, AR);
      await prefs.setString(COUNTRY_CODE, '');
    } else {
      _appLocale = Locale(EN);
      await prefs.setString(LANGUAGE_CODE, EN);
      await prefs.setString(COUNTRY_CODE, US);
    }
    notifyListeners();
  }
}
