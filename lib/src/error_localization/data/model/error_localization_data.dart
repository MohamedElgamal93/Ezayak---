import 'dart:ui';

import 'package:ezayak/src/AppLanguage.dart';

import '../../../../app_constants.dart';

class ErrorLocalization {
  String key;
  String englishMessage;
  String arabicMessage;

  ErrorLocalization({this.key, this.englishMessage, this.arabicMessage});

  ErrorLocalization.fromMap(Map<String, dynamic> map)
      : key = map[KEY],
        englishMessage = map[ENGLISH_MESSAGE],
        arabicMessage = map[ARABIC_MESSAGE];

//  factory ErrorLocalization.fromJson(Map<String, dynamic> json) {
//    return ErrorLocalization(
//      key: json['key'],
//      englishMessage: json['englishMessage'],
//      arabicMessage: json['arabicMessage'],
//    );
//  }

  static List<ErrorLocalization> list;

  static String getErrorLocalString(
      AppLanguage appLanguage, String key, String message) {
    if (key != null && list != null) {
      for (ErrorLocalization err in list) {
        if (err.key == key) {
          if (appLanguage.appLocal == Locale(EN)) {
            return err.englishMessage;
          } else {
            return err.arabicMessage;
          }
        }
      }
      return message;
    }
    return message;
  }
}
